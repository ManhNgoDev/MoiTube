import { Injectable } from "@nestjs/common";

import { v2 as cloudinary, UploadApiResponse} from "cloudinary";
import 'multer';
import { Readable } from "stream";

@Injectable()
export class CloudinaryService {
    constructor() {
        cloudinary.config({
            cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
            api_key: process.env.CLOUDINARY_API_KEY,
            api_secret: process.env.CLOUDINARY_API_SECRET
        })
    }
    //Upload Video----------------------------
    async uploadVideo(file: Express.Multer.File): Promise<UploadApiResponse> {
        return new Promise((resolve, reject) => {
            const uploadStream = cloudinary.uploader.upload_stream(
                {
                    resource_type: 'video',
                    folder: 'moitube/videos'
                },
                (error, result) => {
                    if(error) return reject(error);
                    resolve(result!);
                }
            );
            Readable.from(file.buffer).pipe(uploadStream)
        })
    }
    //Upload Ảnh (thumbnail, avatar, ....)--------------------
    async uploadImage(
        file: Express.Multer.File,
        folder: string = 'moitube/images',
    ): Promise<UploadApiResponse> {
        return new Promise((resolve, reject) => {
            const uploadStream = cloudinary.uploader.upload_stream(
                {
                    resource_type: 'image',
                    folder
                },
                (error, result) => {
                    if(error) return reject(error);
                    resolve(result!);
                }
            )
            Readable.from(file.buffer).pipe(uploadStream)
        })
    }
    //Xóa file-----------------------------------------------------
    async deleteFile(
        publicId: string,
        resourceType: 'video' | 'image' = 'video'
    ): Promise<void> {
        await cloudinary.uploader.destroy(publicId, {
            resource_type: resourceType
        })
    }
    //Lấy public ID---------------------------------------------------
    extracPublicId(url: string): string {
        const parts = url.split('/')
        const fileWithExt = parts[parts.length -1]
        const file = fileWithExt.split('.')[0];
        const folder = parts.slice(parts.indexOf('moitube')).slice(0, -1).join('/');
        return `${folder}/${file}`;
    }

}