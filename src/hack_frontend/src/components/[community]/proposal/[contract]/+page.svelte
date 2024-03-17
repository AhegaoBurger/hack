<script>
    import { backend } from "$lib/canisters";

    import { onMount } from "svelte";

    import * as Card from "$lib/components/ui/card/index"
    import { Button } from '$lib/components/ui/button'

    let proposal = {title: "Reverse gravity", description: "I think it is self explanatory", address: "your_moms_house"}

    async function getProposal() {
        backend.getProposal().then((response) => {

        })
    }
</script>

<div class="font-sans m-4">
    {proposal.description}
</div>


<Card.Root class="w-full m-4">
    <Card.Header>
      <Card.Title>Current results</Card.Title>
      <Card.Description></Card.Description>
    </Card.Header>
    <Card.Content>
        <div>
            <div>
                <p>Yes</p>
                <p class="text-right">0%</p>
            </div>
        </div>
        <div>
            <p>No</p>
            <p class="text-right">0%</p>
        </div>
        <!-- <div>
            <p>Abstain</p>
            <p class="text-right">0%</p>
        </div> -->
    </Card.Content>
    <!-- <Card.Footer class="flex justify-between">
      <Button>Press me to see the truth</Button>
    </Card.Footer> -->
</Card.Root>

