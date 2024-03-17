<script>
    import { backend } from "$lib/canisters";

    import { page } from '$app/stores'

    import { Input } from '$lib/components/ui/input';
    import Button from "$lib/components/ui/button/button.svelte";
    
    let id;
    let title;
    let description; 

    async function createProposal(id, title, description) {
        backend.createProposal(id, title, description).then((response) => {

        })
    }

    $: communityName = $page.params.community

</script>

<a href="/{communityName}"><div class="flex m-4"><svg width="15" height="15" viewBox="0 0 15 15" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M6.85355 3.14645C7.04882 3.34171 7.04882 3.65829 6.85355 3.85355L3.70711 7H12.5C12.7761 7 13 7.22386 13 7.5C13 7.77614 12.7761 8 12.5 8H3.70711L6.85355 11.1464C7.04882 11.3417 7.04882 11.6583 6.85355 11.8536C6.65829 12.0488 6.34171 12.0488 6.14645 11.8536L2.14645 7.85355C1.95118 7.65829 1.95118 7.34171 2.14645 7.14645L6.14645 3.14645C6.34171 2.95118 6.65829 2.95118 6.85355 3.14645Z" fill="currentColor" fill-rule="evenodd" clip-rule="evenodd"></path></svg>Back</div></a>

<Input 
    placeholder="e.g. 1"
    id="id"
    bind:value={id}
    class="w-full m-4"
/>

<Input 
    placeholder="Amendment to X protocol"
    id="title"
    bind:value={title}
    class="w-full m-4"
/>

<Input 
    placeholder="As detailed a description as you can manage"
    id="description"
    bind:value={description}
    class="w-full m-4"
/>

<Button class="m-4" on:click={createProposal}>Create</Button>
