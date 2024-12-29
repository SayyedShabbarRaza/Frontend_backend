const multer=require('multer')
const cloudinary = require('cloudinary').v2;
const path=require('path')
require('dotenv').config();
const fs = require('fs');
const crypto=require('crypto')

// Configuration
cloudinary.config({ 
    cloud_name:process.env.CLOUDINARY_NAME, 
    api_key: process.env.CLOUDINARY_API_KEY, 
    api_secret:process.env.CLOUDINARY_API_SECRET
});


//Multer storage configuration
const storage = multer.diskStorage({
    destination: function (req, file, cb) {
      cb(null, './public/images/uploads')
    },
    filename: function (req, file, cb) {
        crypto.randomBytes(12,function(err,bytes){
            const fn=bytes.toString("hex")+path.extname(file.originalname)
            cb(null, fn)
        })
    }
  })
  const upload = multer({ storage: storage })

const uploadToCloudinary=async (filePath,publicId,folder)=>{
    try{
        const result=await cloudinary.uploader.upload(filePath,{
            public_id:publicId,
            folder:folder
        });
        
        fs.unlink(filePath,(err)=>{
            if(err)console.error("failed to delete local file:",err)
            })
    return result
    }catch(error){
        fs.unlink(filePath,(err)=>{
            if(err)console.error("failed to delete local file after error:",err);
        })
        throw error;
    }
}
module.exports={upload,uploadToCloudinary}




























// (async function() {

    
//     console.log(uploadResult);
// })();

