<!-- src/hack_frontend/src/routes/+page.svelte -->
<script>
  import "../index.scss";

  import { backend } from "$lib/canisters";
  import { Button } from '$lib/components/ui/button'
  import { Input } from '$lib/components/ui/input';
  
  import * as Card from "$lib/components/ui/card/index"

  import { ethers } from 'ethers';

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

  // Reactive statement to auto-update when getBalanceValue changes
  $: {
    if (getBalanceValue) {
      decodeBalance(JSON.stringify(getBalanceValue));
    }
  }

  function decodeBalance(jsonBalance) {
    try {
      const parsedJson = JSON.parse(jsonBalance);
      // console.log("Parsed Json:", parsedJson)
      const innerJson = JSON.parse(parsedJson.ok);
      // console.log("Inner Json:", innerJson)
      const hexBalance = innerJson.result;
      // console.log("Hex balance Json:", hexBalance)
      const bigNumberValue = ethers.BigNumber.from(hexBalance);
      // console.log("Big Number value: ", bigNumberValue)
      const etherValue = ethers.utils.formatEther(bigNumberValue);
      // console.log("Balance in ETH:", etherValue)
      testRPCValue = `Balance in ETH: ${etherValue}`; // Update the UI with the decoded value
    } catch (error) {
      // console.error("Error decoding balance:", error);
      testRPCValue = 'Error decoding balance';
    }
  }

</script>



<main>
  <img src="/banner.png" alt="Hack logo" />
  <br />
  <br />
  <!-- <form action="#" on:submit|preventDefault={onSubmit}>
    <label for="name">Enter your name: &nbsp;</label>
    <Input id='name' alt='Name' type='text' />
    <Button type='submit'>Click Me!</Button>
  </form>
  <section id="greeting">{greeting}</section> -->

  <section class="m-4 max-w-4xl mx-auto">
    <h1 class="text-3xl font-bold text-center mb-4">Ethereum DAO Governance Platform</h1>
    <p class="text-lg text-gray-700 mb-4">
        Welcome to our Governance Platform, a revolutionary tool designed specifically for Ethereum-based Decentralized Autonomous Organizations (DAOs). Our platform enables seamless, transparent, and secure on-chain voting, empowering DAO members to make informed decisions efficiently.
    </p>
    <br>
    <p class="text-lg text-gray-700 mb-4">
        Built on the innovative Internet Computer Protocol (ICP) and utilizing Svelte for a responsive and dynamic user experience, our platform ensures high performance and robust security. TailwindCSS enhances the interface with an intuitive and modern design, making governance an engaging and straightforward process.
    </p>
    <br>
    <p class="text-lg text-gray-700 mb-4">
        Features include real-time proposal submissions, voting systems, and automated notifications, all integrated within a user-friendly dashboard. HTTP Outcalls and backend interactions are streamlined, ensuring that your DAO operations are as efficient as they are effective.
    </p>
    <br>
    <p class="text-lg text-gray-700">
        Join us in reshaping the future of decentralized governance. Empower your DAO with the tools it needs to succeed and make every vote count with our comprehensive Governance Platform.
    </p>
</section>
</main>


<!-- <Card.Root class="w-[350px]">
  <Card.Header>
    <Card.Title>Create project</Card.Title>
    <Card.Description>Deploy your new project in one-click.</Card.Description>
  </Card.Header>
  <Card.Content>
    {testRPCValue}
  </Card.Content>
  <Card.Footer class="flex justify-between">
    <Button on:click={testRPC}>Press me to check for the RPC</Button>
  </Card.Footer>
</Card.Root> -->

