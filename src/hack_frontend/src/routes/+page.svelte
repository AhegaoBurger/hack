<script>
  import "../index.scss";

  import { AuthClient } from "@dfinity/auth-client";
  import { onMount } from "svelte";
  import { auth, createActor } from '../store/auth';
  import { backend } from "$lib/canisters";
  import { Button } from '$lib/components/ui/button'
  import { Input } from '$lib/components/ui/input';
  
  import * as Card from "$lib/components/ui/card/index"

  /** @type {AuthClient} */
  let client;

  let whoami = $auth.actor.whoami();

  onMount(async () => {
      client = await AuthClient.create();
      if (await client.isAuthenticated()) {
      handleAuth();
      }
  });

  function handleAuth() {
      auth.update(() => ({
      loggedIn: true,
      actor: createActor({
          agentOptions: {
          identity: client.getIdentity(),
          },
      }),
      }));

      whoami = $auth.actor.whoami();
  }

  let greeting = "";

  function onSubmit(event) {
    const name = event.target.name.value;
    backend.greet(name).then((response) => {
      greeting = response;
    });
    return false;
  }

  let testRPCValue = "Nothing yet";

  async function testRPC() {
		backend.getBalanceTokens().then((response) => {
      testRPCValue = response
    })
	}


</script>



<main>
  <img src="/logo2.svg" alt="DFINITY logo" />
  <br />
  <br />
  <form action="#" on:submit|preventDefault={onSubmit}>
    <label for="name">Enter your name: &nbsp;</label>
    <Input id='name' alt='Name' type='text' />
    <!-- <input id="name" alt="Name" type="text" /> -->
    <Button type='submit'>Click Me!</Button>
    <!-- <button type="submit">Click Me!</button> -->
  </form>
  <section id="greeting">{greeting}</section>
  <!-- <Auth /> -->
</main>

<div>
  {#await whoami}
    Querying caller identity...
  {:then principal}
    Your principal ID is
    <code>{principal}</code>

    {#if principal.isAnonymous()}
      (anonymous)
    {/if}
  {/await}
</div>

<Card.Root class="w-[350px]">
  <Card.Header>
    <Card.Title>Create project</Card.Title>
    <Card.Description>Deploy your new project in one-click.</Card.Description>
  </Card.Header>
  <Card.Content>
    {JSON.stringify(testRPCValue)}
  </Card.Content>
  <Card.Footer class="flex justify-between">
    <Button on:click={testRPC}>Press me to check for the RPC</Button>
  </Card.Footer>
</Card.Root>

