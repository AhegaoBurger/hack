<script>
    import { backend } from "$lib/canisters";

    import { Button } from '$lib/components/ui/button'
    import { Input } from '$lib/components/ui/input';
    import * as AlertDialog from '$lib/components/ui/alert-dialog/index'
    import { toast } from "svelte-sonner";

    let smartContractAddress;
    let communityName;

    async function createCommunity() {
        
        backend.createCommunity(smartContractAddress, communityName).then((response) => {
            
        });
        toast.success("Your community has been created", {
            description: "Start this journey by creating your first proposal."
        })
    }

</script>

<h1 class="font-sans text-4xl m-4"><b>Create a space</b></h1>

<p class="font-sans m-4">Hack is a free, ICP-based platform for community governance. Create your own space now and start making decisions!</p>

<Input 
    class="m-4"
    bind:value={smartContractAddress}
    placeholder="Your community's smart contract adsress"
/>

<Input 
    class="m-4" 
    bind:value={communityName}
    placeholder="Your community's name"
/>


<AlertDialog.Root>
    <AlertDialog.Trigger asChild let:builder>
      <Button class="m-4" builders={[builder]} variant="outline">Create Community</Button>
    </AlertDialog.Trigger>
    <AlertDialog.Content>
      <AlertDialog.Header>
        <AlertDialog.Title>Please confirm the details</AlertDialog.Title>
        <AlertDialog.Description>
          <div>Smart contract adress: {smartContractAddress}</div>
          <div>Community name: {communityName}</div>
        </AlertDialog.Description>
      </AlertDialog.Header>
      <AlertDialog.Footer>
        <AlertDialog.Cancel>Cancel</AlertDialog.Cancel>
        <AlertDialog.Action on:click={createCommunity}>Continue</AlertDialog.Action>
      </AlertDialog.Footer>
    </AlertDialog.Content>
</AlertDialog.Root>
  
  