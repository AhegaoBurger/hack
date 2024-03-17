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

<a href="/{communityName}"><div class="m-4">Back</div></a>

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
