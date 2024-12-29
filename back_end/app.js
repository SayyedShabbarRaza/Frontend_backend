const express = require('express')
const bcrypt = require('bcrypt')
const jwt = require('jsonwebtoken')
const cors = require('cors')
const path = require('path');
const userModel = require('./models/user.model.js')
const postModel = require('./models/post.model.js')
const { default: mongoose } = require('mongoose')
const { upload, uploadToCloudinary } = require('./cloudinary.js')
const app = express()

app.use(cors())
app.use(express.json())
app.use(express.urlencoded({ extended: true }))

//Authentication

app.post('/api/register', upload.single('image'), async (req, res) => {
    let { name, username, age, email, password } = req.body
    let user = await userModel.findOne({ email })

    //User Already Exists
    if (user) {
        return res.status(409).send(
            {
                "status": "409",
                "message": "user already exists"
            }
        )
    }
    //Creating Salt
    bcrypt.genSalt(10, (err, salt) => {
        bcrypt.hash(password, salt, async (err, hash) => {
            let newUser = await userModel.create({
                name,
                username,
                age,
                email,
                password: hash
            })

            try{
                if(!req.file){
                    return res.status(400).json({message:'No  uploaded'})
                }
        
                const filePath=req.file.path;
                const publicId=path.parse(req.file.originalname).name
                const folder='avatars'
        
                result=await uploadToCloudinary(filePath,publicId,folder)
                newUser.avatar=result.secure_url
                await newUser.save()
            }catch(error){
                res.status(500).json({
                    message:'File upload failed',
                    error
                })
            }
            //JWT
            let token = jwt.sign(
                {
                    email,
                    userId: newUser._id,
                },
                "shhhh"
            )
            res.status(200).send({
                "status":200,
                "token": token,
                "message": "Registered Successfully",
            });

        })
    })

})

app.post('/api/login', async (req, res) => {
    let { email, password } = req.body
    let user = await userModel.findOne({ email })
    console.log(user.avatar)
    if (!user) return res.status(500).send({ "status": "500", "message": "Something went wrong" })

    bcrypt.compare(password, user.password, function (err, result) {
        if (result) {

            //JWT
            let token = jwt.sign(
                {
                    email,
                    userId: user._id,
                },
                "shhhh"
            )

            res.status(200).send({ "status": "200", "token": token, "message": "Logged IN","user":user })
        }
        else {
            res.status(500).send({ "status": "500", "message": "Wrong credentials" })
        }
    })
})

function isLoggedIN(req, res, next) {
    let token = req.headers.authorization
    if (req.Authorization === "")
        res.status(500).send({ "message": "You must be logged in" });
    else {
        let data = jwt.verify(token.replace('Bearer ', ''), "shhhh");
        req.user = data;
        next();
    }
}

//Posts
app.post('/api/post', isLoggedIN, async (req, res) => {
    let user = await userModel.findOne({ email: req.user.email })
    let data = req.body.post

    let post = await postModel.create({
        user: user._id,
        content: data
    })
    user.posts.push(post._id)
    await user.save()

    res.status(200).json({
        "status": "200",
        "message": "post submitted successfully",
    })
})

app.get('/api/getPost', isLoggedIN, async (req, res) => {

    let user = await userModel.findOne({ email: req.user.email }).populate("posts")
    if(user)
    res.status(200).send(user.posts.reverse());
})


app.get('/api/like/:id', isLoggedIN, async (req, res) => {
    let post = await postModel.findOne({ _id: req.params.id }).populate("user");
    if (post.likes.indexOf(req.user.userId) === -1) {
        post.likes.push(req.user.userId)
        await post.save()
        res.status(200).json({
            status: 200,
            message: "Post Liked",
            isLiked: true,
        });
    }
    else {
        post.likes.splice(post.likes.indexOf(req.user.userId), 1)

        await post.save()
        res.status(200).json({
            status: 200,
            message: "Post unliked",
            isLiked: false,
        });
    }
});

app.post('/api/update/:id', isLoggedIN, async (req, res) => {
    let post = await postModel.findOneAndUpdate({ _id: req.params.id },{content:req.body.post});
    
    if(!post){
        res.status(500).json({
            "status": 500,
            "message": "An error occured",
        })
    }
    else{
        res.status(200).json({
            "status": 200,
            "message": "post updated successfully",
        })
    }
    
});

app.get('/api/delete/:id', isLoggedIN, async (req, res) => {
    let post = await postModel.findOneAndDelete({ _id: req.params.id })
    
    if(!post){
        res.status(500).json({
            "status":500,
            "message":"Something Went Wrong"
        })
    }
    else{
        res.status(200).json({
            "status":200,
            "message":"Item Deleted"
        })
    }

});

// app.post('/api/upload',upload.single("image"),async (req,res)=>{
//     try{
//         if(!req.file){
//             return res.status(400).json({message:'No  uploaded'})
//         }

//         const filePath=req.file.path;
//         const publicId=path.parse(req.file.originalname).name
//         const folder='avatars'

//         result=await uploadToCloudinary(filePath,publicId,folder)
//         res.status(200).json({
//             message:'File uploaded successfully',
//             url:result.secure_url
//         })
//     }catch(error){
//         res.status(500).json({
//             message:'File upload failed',
//             error
//         })
//     }
// })

//Logout
// app.get('/logout',(req,res)=>{
    //     res.status(200).json({"token":null,"message": "Logged IN",})
    // })
    app.listen(3000)