<script>
  // /** @type {import('./$types').LayoutData} */
	// export let data;

  import { backend } from "$lib/canisters";

  import { page } from '$app/stores'

  import * as Avatar from "$lib/components/ui/avatar/index.ts";
	import * as Card from "$lib/components/ui/card/index"
  import Button from "$lib/components/ui/button/button.svelte";
  import { onMount } from "svelte";

  let proposals = [{title: "Reverse gravity", description: "We want to reverse gravity for the bettering of humanity and definitely not to sell expensive earth teathers", address: "0"}, {title: "Kill God", description: "I think it is self explanatory", address: "1"}]

  let canisterId = process.env.CANISTER_ID_HACK_FRONTEND

  $: communityName = $page.params.community

  let communityId;

  // Function to fetch community ID
  async function fetchCommunityId() {
    const response = await backend.getAllCommunities();
    let communities = response.map((item) => ({
      id: item.id,
      members: item.members,
      admin: item.admin,
      name: item.name,
      address: item.smartContractAddr
    }))
    
    let community = communities.find(c => c.name === communityName);

    if (community) {
      communityId = community.id;
      console.log("CommunitId is", communityId)
      await getAllProposalsByCmt(communityId); // Move proposal fetching here
    }

    communityId = community.id
  }

  function capitalizeFirstLetter(string) {
      return string.charAt(0).toUpperCase() + string.slice(1);
  }

  async function getAllProposalsByCmt(communityId) {
    if (!communityId) return; // Check if communityId is available
    const response = await backend.getAllProposalsByCmt(communityId);
    console.log("The response is ", response)
    proposals = response.map(item => ({
      title: item.name,
      description: item.description,
      address: item.id // Make sure 'item' has 'name', 'description', 'id'
    }));

    console.log("The proposals in the functions are", proposals)
  }

  onMount(() => {
    fetchCommunityId()
    // getAllProposalsByCmt(communityId)
    console.log("communityId is ", communityId)
    console.log("The proposals are ", proposals)
  })

</script>

<!-- {#each data.url as url}
  <a href="/proposals/{url}">{url}</a>
{/each} -->

<main class="relative">
  <Card.Root class="w-full m-4">
      <Card.Header>
        <Card.Title>{capitalizeFirstLetter(communityName)}'s community</Card.Title>
        <Card.Description>An endless odyssey of fun</Card.Description>
      </Card.Header>
      <Card.Content>
        We are here to have fun and make decisions
        <!-- {JSON.stringify(testRPCValue)} -->
      </Card.Content>
      <Card.Footer class="flex justify-between">
        <Button>You look good today</Button>
      </Card.Footer>
  </Card.Root>

  <div class="static">
    <a href="/{communityName}/create"><Button class="absolute insety-y-0 right-0" variant='outline'>New Proposal</Button></a>
  </div>

  <div>
    <section class="cols-4">
      {#each proposals as proposal}
        <a href="{communityName}/proposal/{proposal.address}">
          <Card.Root class="w-1/2 m-4">
            <Card.Header>
              <Card.Description>{proposal.address}</Card.Description>
              <div></div>
              <Card.Title tag="h3">{proposal.title}</Card.Title>
            </Card.Header>
            <Card.Content>
                    <p>{proposal.description}</p>
            </Card.Content>
            <Card.Footer class="flex justify-between">
              <Button>Press me to see the truth</Button>
            </Card.Footer>
          </Card.Root>
        </a>
      {/each}
    </section>
  </div>
</main>