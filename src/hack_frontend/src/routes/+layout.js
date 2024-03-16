export const prerender = true;

import { backend } from '$lib/canisters'

async function getAllCommunities() {
    try {
        const response = backend.getAllCommunities();
        const data = JSON.parse(response); // Assuming 'response' is a JSON string. Adjust as necessary.

        // Now, map the data to fit your 'communities' structure
        return communities = data.map((item) => ({
            name: item.name,
            address: item.smartContractAddr
        }));
    } catch (error) {
        console.error("Failed to load communities:", error);
        return error;
    }
}
    
 
/** @type {import('./$types').PageLoad} */
export async function load() {
    return {
        communities: await getAllCommunities()
    }
}