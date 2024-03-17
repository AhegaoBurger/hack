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
</script>

<Input 
    placeholder="e.g. 1"
    id="id"
    bind:value={id}
    class="w-full"
/>

<Input 
    placeholder="Amendment to X protocol"
    id="title"
    bind:value={title}
    class="w-full"
/>

<Input 
    placeholder="As detailed a description as you can manage"
    id="description"
    bind:value={description}
    class="w-full"
/>
