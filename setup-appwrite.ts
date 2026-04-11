import { Client, Databases, Storage, ID, Permission, Role, Compression } from 'node-appwrite';

/**
 * Setup script for Instagram Clone Appwrite Backend
 * 
 * Run with: npx ts-node setup-appwrite.ts
 * Or: bun setup-appwrite.ts
 */

const ENDPOINT = 'https://sgp.cloud.appwrite.io/v1';
const PROJECT_ID = '695103540022da68cbb9';
const API_KEY = 'standard_cb1b68cd56ded441f44286a3f4e935574562072f4af8fbcdbe419c4b670d862fde190a2adbbf891acb1441a235b48a7f2503219dbfaba8e311be915decc5664dae50215491b4401fc8824aec9809e7dccdc448b88daefa94974dd4387b9160e292e0272b3d3cbbf62755b62f264b14c20a5684837b5794eed29efb6a0d389e6c';

const client = new Client()
    .setEndpoint(ENDPOINT)
    .setProject(PROJECT_ID)
    .setKey(API_KEY);

const databases = new Databases(client);
const storage = new Storage(client);

async function setup() {
    console.log('🚀 Starting Appwrite Setup...');

    try {
        // 1. Create Database
        const dbId = 'instagram_db';
        console.log(`Creating database: ${dbId}...`);
        await databases.create(dbId, 'Instagram Database');

        // 2. Create Storage Buckets
        const postsBucketId = 'posts_bucket';
        console.log(`Creating storage bucket: ${postsBucketId}...`);
        await storage.createBucket(
            postsBucketId,
            'Posts Media',
            [Permission.read(Role.any()), Permission.write(Role.users())],
            false, // fileSecurity
            true, // enabled
            undefined, // maximumFileSize
            ['jpg', 'png', 'jpeg', 'mp4'], // allowedFileExtensions
            Compression.None, // compression
            true, // encryption
            true // antivirus
        );

        // 3. Create Collections
        const collections = [
            {
                id: 'posts',
                name: 'Posts',
                attributes: [
                    { key: 'userId', type: 'string', size: 255, required: true },
                    { key: 'imageUrl', type: 'string', size: 1024, required: true },
                    { key: 'caption', type: 'string', size: 5000, required: false },
                    { key: 'createdAt', type: 'datetime', required: true },
                ]
            },
            {
                id: 'likes',
                name: 'Likes',
                attributes: [
                    { key: 'userId', type: 'string', size: 255, required: true },
                    { key: 'postId', type: 'string', size: 255, required: true },
                ]
            },
            {
                id: 'comments',
                name: 'Comments',
                attributes: [
                    { key: 'userId', type: 'string', size: 255, required: true },
                    { key: 'postId', type: 'string', size: 255, required: true },
                    { key: 'text', type: 'string', size: 2000, required: true },
                    { key: 'createdAt', type: 'datetime', required: true },
                ]
            },
            {
                id: 'followers',
                name: 'Followers',
                attributes: [
                    { key: 'followerId', type: 'string', size: 255, required: true },
                    { key: 'followingId', type: 'string', size: 255, required: true },
                ]
            }
        ];

        for (const col of collections) {
            console.log(`Creating collection: ${col.name}...`);
            await databases.createCollection(dbId, col.id, col.name, [
                Permission.read(Role.any()),
                Permission.create(Role.users()),
                Permission.update(Role.users()),
                Permission.delete(Role.users()),
            ]);

            for (const attr of col.attributes) {
                console.log(`  Adding attribute: ${attr.key} to ${col.id}...`);
                if (attr.type === 'string') {
                    await databases.createStringAttribute(dbId, col.id, attr.key, attr.size!, attr.required);
                } else if (attr.type === 'datetime') {
                    await databases.createDatetimeAttribute(dbId, col.id, attr.key, attr.required);
                }
            }
            console.log(`✅ Collection ${col.name} setup complete.`);
        }

        console.log('🎉 Appwrite Backend Setup Successfully!');
    } catch (error: any) {
        console.error('❌ Error during setup:', error.message);
    }
}

setup();
