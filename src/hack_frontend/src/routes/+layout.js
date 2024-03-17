// src/hack_frontend/src/routes/+layout.js
/** @type {import('./$types').PageLoad} */

import { backend } from '$lib/canisters'

// // Modified getAllCommunities to return data
// async function getAllCommunities() {
//     const response = await backend.getAllCommunities(); // Make sure this is awaited
//     return response.map(item => ({
//         name: item.name,
//         address: item.smartContractAddr
//     }));
// }

let communities = [{name: "hack", address: "test"}, {name: "artur", address: "done"}]

export async function load() {
    // const communities = await getAllCommunities(); // Fetch communities asynchronously
    return {
        communities

    }
}

export const prerender = 'auto';