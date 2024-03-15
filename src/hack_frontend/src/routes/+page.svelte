<script>
  import "../index.scss";

  // import { AuthClient } from "@dfinity/auth-client";
  // import { onMount } from "svelte";
  // import { auth, createActor } from '../store/auth';
  import { backend } from "$lib/canisters";
  import { Button } from '$lib/components/ui/button'
  import { Input } from '$lib/components/ui/input';
  
  import * as Card from "$lib/components/ui/card/index"

  import { ethers } from 'ethers';

  // /** @type {AuthClient} */
  // let client;

  // let whoami = $auth.actor.whoami();

  // onMount(async () => {
  //     client = await AuthClient.create();
  //     if (await client.isAuthenticated()) {
  //     handleAuth();
  //     }
  // });

  // function handleAuth() {
  //     auth.update(() => ({
  //     loggedIn: true,
  //     actor: createActor({
  //         agentOptions: {
  //         identity: client.getIdentity(),
  //         },
  //     }),
  //     }));

  //     whoami = $auth.actor.whoami();
  // }

  let greeting = "";

  function onSubmit(event) {
    const name = event.target.name.value;
    backend.greet(name).then((response) => {
      greeting = response;
    });
    return false;
  }

  let testRPCValue = "Nothing yet";
  let getBalanceValue = {"ok":"{\"id\":1,\"jsonrpc\":\"2.0\",\"result\":\"0x3cd28c9e8e000\"}"}

  async function testRPC() {
		backend.getBalanceTokens().then((response) => {
      testRPCValue = response
    })
	}

  // function decodeBalance(jsonBalance) {
  //       try {
  //           const parsedJson = JSON.parse(jsonBalance);
  //           console.log("Parsed Json:", parsedJson)
  //           const innerJson = JSON.parse(parsedJson.ok);
  //           console.log("Inner Json:", innerJson)
  //           const hexBalance = innerJson.result;
  //           console.log("Hex balance Json:", hexBalance)
  //           const bigNumberValue = ethers.BigNumber.from(hexBalance);
  //           const etherValue = ethers.utils.formatEther(bigNumberValue);
  //           console.log("ethers value:", etherValue)
  //           // return parseInt(etherValue, 16);
  //       } catch (error) {
  //           console.error("Error decoding balance:", error);
  //           return 'N/A';
  //       }
  //   }

  // Reactive statement to auto-update when getBalanceValue changes
  $: {
    if (getBalanceValue) {
      decodeBalance(JSON.stringify(getBalanceValue));
    }
  }

  function decodeBalance(jsonBalance) {
    try {
      const parsedJson = JSON.parse(jsonBalance);
      console.log("Parsed Json:", parsedJson)
      const innerJson = JSON.parse(parsedJson.ok);
      console.log("Inner Json:", innerJson)
      const hexBalance = innerJson.result;
      console.log("Hex balance Json:", hexBalance)
      const bigNumberValue = ethers.BigNumber.from(hexBalance);
      console.log("Big Number value: ", bigNumberValue)
      const etherValue = ethers.utils.formatEther(bigNumberValue);
      console.log("Balance in ETH:", etherValue)
      testRPCValue = `Balance in ETH: ${etherValue}`; // Update the UI with the decoded value
    } catch (error) {
      console.error("Error decoding balance:", error);
      testRPCValue = 'Error decoding balance';
    }
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


<Card.Root class="w-[350px]">
  <Card.Header>
    <Card.Title>Create project</Card.Title>
    <Card.Description>Deploy your new project in one-click.</Card.Description>
  </Card.Header>
  <Card.Content>
    {testRPCValue}
    <!-- {JSON.stringify(testRPCValue)} -->
  </Card.Content>
  <Card.Footer class="flex justify-between">
    <Button on:click={testRPC}>Press me to check for the RPC</Button>
  </Card.Footer>
</Card.Root>

