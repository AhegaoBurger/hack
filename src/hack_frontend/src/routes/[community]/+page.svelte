<script>
  /** @type {import('./$types').LayoutData} */
	export let data;

  import { backend } from "$lib/canisters";

  import * as Avatar from "$lib/components/ui/avatar/index.ts";
	import * as Card from "$lib/components/ui/card/index"
  import Button from "$lib/components/ui/button/button.svelte";

  let proposals = [{title: "Reverse gravity", description: "I think it is self explanatory", address: "your_moms_house"}, {title: "Kill God", description: "I think it is self explanatory", address: "your_moms_house"}]

</script>

{#each data.url as url}
  <a href="/proposals/{url}">{url}</a>
{/each}

<Card.Root class="w-full m-4">
    <Card.Header>
      <Card.Title>Artur's community</Card.Title>
      <Card.Description>An endless odyssey of fun</Card.Description>
    </Card.Header>
    <Card.Content>
      Name of the community
      <!-- {JSON.stringify(testRPCValue)} -->
    </Card.Content>
    <Card.Footer class="flex justify-between">
      <Button>Press me to see the truth</Button>
    </Card.Footer>
</Card.Root>

<section class="flex">

  {#each proposals as proposal}
    <Card.Root class="w m-4">
      <Card.Header>
        <Card.Description>{proposal.address}</Card.Description>
        <div></div>
        <Card.Title tag="h3">{proposal.title}</Card.Title>
        <!-- <Card.Description>{proposal.description}</Card.Description> -->
      </Card.Header>
      <Card.Content>
              <p>{proposal.description}</p>
      </Card.Content>
      <Card.Footer class="flex justify-between">
        <Button>Press me to see the truth</Button>
      </Card.Footer>
    </Card.Root>
  {/each}
</section>
