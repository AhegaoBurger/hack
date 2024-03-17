<script>
  // /** @type {import('./$types').LayoutData} */
	// export let data;

  import { backend } from "$lib/canisters";

  import { page } from '$app/stores'

  import * as Avatar from "$lib/components/ui/avatar/index.ts";
	import * as Card from "$lib/components/ui/card/index"
  import Button from "$lib/components/ui/button/button.svelte";
  import { onMount } from "svelte";

  let proposals = [{title: "Reverse gravity", description: "I think it is self explanatory", address: "your_moms_house"}, {title: "Kill God", description: "I think it is self explanatory", address: "your_dads_house"}]

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

    const community = communities.find(c => c.name === communityName);
    communityId = community.id
  }

  function capitalizeFirstLetter(string) {
      return string.charAt(0).toUpperCase() + string.slice(1);
  }

  onMount(async () => {
    getAllProposalsByCmt()
  })

  async function getAllProposalsByCmt(communityId) {
    await backend.getAllProposalsByCmt(communityId).then((response) => {
      proposals = response.map((item) => ({
        title: item.name,
        description: item.description,
        address: item.id
      }));
    })
  }

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
        Name of the community
        <!-- {JSON.stringify(testRPCValue)} -->
      </Card.Content>
      <Card.Footer class="flex justify-between">
        <Button>Press me to see the truth</Button>
      </Card.Footer>
  </Card.Root>

  <div class="static">
    <a href="/{communityName}/create"><Button class="absolute insety-y-0 right-0" variant='outline'>New Proposal</Button></a>
  </div>

  <div>
    <section class="flex">
      {#each proposals as proposal}
        <a href="{communityName}/proposal/{proposal.address}">
          <Card.Root class="w m-4">
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