<!-- src/hack_frontend/src/routes/+Layout.svelte -->
<script>
    import "../app.pcss";

	// import { AuthClient } from "@dfinity/auth-client";
	// import { auth, createActor } from "../store/auth";

	import { backend } from "$lib/canisters";

    import Button from "$lib/components/ui/button/button.svelte";
	import * as DropdownMenu from "$lib/components/ui/dropdown-menu/index.ts"; 
	import * as Avatar from "$lib/components/ui/avatar/index.ts";
	import * as Card from "$lib/components/ui/card/index"
	import { Badge } from '$lib/components/ui/badge/index'
	import { Separator } from '$lib/components/ui/separator/index'
	import { Toaster } from "svelte-sonner";

	import { onMount } from "svelte";

	import { ethers } from 'ethers';

	import { createAvatar } from '@dicebear/avatars';
  	import * as style from '@dicebear/avatars-identicon-sprites';

	let svg;

	let communities;

	export let data;

	// /** @type {AuthClient} */
    // let client;

    // let whoami = $auth.actor.whoami();

    onMount(async () => {
        // client = await AuthClient.create();
        // if (await client.isAuthenticated()) {
        // handleAuth();
        // }

		// Now, map the data to fit your 'communities' structure
		communities = data.communities.map((item) => ({
			name: item.name,
			address: item.smartContractAddr
		}));

		communities = await getAllCommunities()

		svg = createAvatar(style, {
			seed: 'your-custom-seed', // Use a unique identifier here
			// any other options
		});
    });

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

    // function login() {
    //     client.login({
    //     identityProvider:
    //         process.env.DFX_NETWORK === "ic"
    //         ? "https://identity.ic0.app/#authorize"
    //         : `http://${process.env.CANISTER_ID_INTERNET_IDENTITY}.localhost:4943/#authorize`,
    //     onSuccess: handleAuth,
    //     });
    // }

    // async function logout() {
    //     await client.logout();
    //     auth.update(() => ({
    //     loggedIn: false,
    //     actor: createActor(),
    //     }));

    //     whoami = $auth.actor.whoami();
    // }

	async function getAllCommunities() {
		const response = await backend.getAllCommunities(); // Make sure this is awaited
		// console.log("The communites are ", response)
		return response.map(item => ({
			name: item.name,
			address: item.smartContractAddr
		}));
	}

	console.log("After all the ops the communities are ", communities)

	// let communities = [{name: "hack", address: "test"}, {name: "artur", address: "done"}];

	let balance = 'N/A';
	let MetaMaskAdress;
    let isConnected = false;

	let canisterId = process.env.CANISTER_ID_HACK_FRONTEND

	function abbreviateAddress(address, charsToShow = 4) {
		if (!address || address.length < charsToShow * 2) {
		return address;
		}
		const start = address.substring(0, charsToShow);
		const end = address.substring(address.length - charsToShow);
		return `${start}...${end}`;
	}

	async function connectWallet() {
        if (window.ethereum) {
            try {
                const provider = new ethers.providers.Web3Provider(window.ethereum);
                await provider.send("eth_requestAccounts", []);
                const signer = provider.getSigner();
				// console.log("The signer is: ", signer)
                const address = await signer.getAddress();
				MetaMaskAdress = address;
				// console.log("The adress is: ", address)
                await updateBalance(address);
                isConnected = true;
            } catch (error) {
                console.error("The error is", error);
            }
        } else {
            console.log('MetaMask is not installed');
        }
    }

    async function updateBalance(address) {
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const balanceBigNumber = await provider.getBalance(address);
        balance = ethers.utils.formatEther(balanceBigNumber);
    }

	function capitalizeFirstLetter() {
        return string.charAt(0).toUpperCase() + string.slice(1);
    }
	

</script>
<Toaster />
<section class="flex h-full">
	<!-- Vertical Navbar -->
	<sidebar class="border-r">
		<div class="w-16 flex flex-col items-center py-4 space-y-4">
			<!-- Icons or logo -->
			<img src="/logo.png" alt="">
			<!-- Navigation Icons -->
			<div class="flex flex-col space-y-2">
				<!-- Replace with your actual icons -->
				{#if communities}
					{#each communities as community }
						<a href="/{community.name}" class="p-2 hover:bg-gray-700 rounded-md"><img src="/favicon.ico" alt="" class="w-6 h-6"></a>
					{/each}
				{:else}
					<div></div>
				{/if}					
				<Separator />
				<!-- <a href="/" class="p-2 hover:bg-gray-700 rounded-md"><img src="/favicon.ico" alt="Dashboard" class="w-6 h-6"></a>
				<a href="/" class="p-2 hover:bg-gray-700 rounded-md"><img src="/favicon.ico" alt="Dashboard" class="w-6 h-6"></a> -->
				<a href="/setup" class="p-2 hover:bg-gray-700 rounded-md"><img src="/plus-solid.svg" alt="Dashboard" class="w-6 h-6"></a>
				<!-- Add more navigation items here -->
			</div>
		</div>
	</sidebar>

	<section class="w-full">
		<div class="hidden flex-col md:flex">
			<!-- Main Content -->
			<div class="border-b">
				<div class="flex h-16 items-center px-4">
					<!-- <div class="max-w-7xl py-6 sm:px-6 lg:px-8"> -->
						<!-- Your content here -->
						<nav class="flex items-center space-x-4 lg:space-x-6">
							<a 
								href='/'
								class="text-sm font-medium text-muted-foreground transition-colors hover:text-primary"
							>
								
								Overview
							</a>
		
							<!-- <a
								href="/faq"
								class="text-sm font-medium text-muted-foreground transition-colors hover:text-primary"
							>
								FAQ
							</a>
							<a
								href="/about"
								class="text-sm font-medium text-muted-foreground transition-colors hover:text-primary"
							>
								Reports
							</a> -->
						</nav>
		
						<div class="ml-auto flex items-center space-x-4">
							<!-- {#if $auth.loggedIn} -->
								<!-- <div>Wallet Balance: {balance} ETH</div> -->
								<DropdownMenu.Root>
									<DropdownMenu.Trigger asChild let:builder>
										<Button variant="ghost" builders={[builder]} class="relative h-8 w-8 rounded-full">
											<!-- <Badge class="w-10 h-5">
												{#if MetaMaskAdress}
													{abbreviateAddress(MetaMaskAdress)}
												{:else}
													A
												{/if}
											</Badge> -->
											<Avatar.Root class="h-8">
												<Avatar.Fallback>
													<!-- {#if MetaMaskAdress}
														{abbreviateAddress(MetaMaskAdress)}
													{:else} -->
														A
													<!-- {/if} -->
												</Avatar.Fallback>
											</Avatar.Root>
										</Button>
									</DropdownMenu.Trigger>
									<DropdownMenu.Content class="w-56" align="end">
										<DropdownMenu.Label class="font-normal">
											<div class="flex flex-col space-y-1">
												<p class="text-sm font-medium leading-none">
													{#if MetaMaskAdress}
														{abbreviateAddress(MetaMaskAdress)}
													{:else}
														A
													{/if}
													<!-- Name and Surname -->
												</p>
												<p class="text-xs leading-none text-muted-foreground">
													<!-- {#if MetaMaskAdress}
														{MetaMaskAdress}
													{/if}
													Name -->
												</p>
											</div>
										</DropdownMenu.Label>
										<DropdownMenu.Separator />
										<DropdownMenu.Group>
											<DropdownMenu.Item>
												Profile
												<DropdownMenu.Shortcut>⇧⌘P</DropdownMenu.Shortcut>
											</DropdownMenu.Item>
											<DropdownMenu.Item >
												Billing
												<DropdownMenu.Shortcut>⌘B</DropdownMenu.Shortcut>
											</DropdownMenu.Item>
											<DropdownMenu.Item>
												Settings
												<DropdownMenu.Shortcut>⌘S</DropdownMenu.Shortcut>
											</DropdownMenu.Item>
										</DropdownMenu.Group>
										<DropdownMenu.Separator />
										<DropdownMenu.Item>
											Log out
											<DropdownMenu.Shortcut>⇧⌘Q</DropdownMenu.Shortcut>
										</DropdownMenu.Item>
										<!-- <DropdownMenu.Item on:click={logout}>
											Log out
											<DropdownMenu.Shortcut>⇧⌘Q</DropdownMenu.Shortcut>
										</DropdownMenu.Item> -->
									</DropdownMenu.Content>
								</DropdownMenu.Root>


								<!-- {#if isConnected === false} -->
									<Button on:click={connectWallet} disabled={isConnected}>Connect Wallet</Button>
								<!-- {:else}

								{/if} -->
							<!-- {:else}
								<Button on:click={login}>Log in</Button>
							{/if} -->
						</div>
					<!-- </div> -->
				</div>
			</div>
		</div>		
		
		<slot />
		</section>
		
</section>
