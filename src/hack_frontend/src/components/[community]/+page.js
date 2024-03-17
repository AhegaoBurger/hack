/** @type {import('./$types').PageLoad} */
export function load({ url }) {
    console.log(url.pathname); 
    return {
        url: url.pathname
    }
}

export const prerender = true;