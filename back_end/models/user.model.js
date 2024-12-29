const mongoose=require('mongoose')

mongoose.connect("mongodb+srv://syedshabbarraza207:2071975@cluster0.zdgv7.mongodb.net/crud")

const userSchema=mongoose.Schema({
    name:String,
    username:String,
    age:Number,
    email:String,
    password:String,
    posts:[
        {
            type:mongoose.Schema.Types.ObjectId,
            ref:"post"
        }
    ],
    avatar:String
})

module.exports=mongoose.model("user",userSchema)