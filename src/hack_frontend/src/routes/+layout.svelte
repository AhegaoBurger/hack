<script>
    import "../app.pcss";

    import { AuthClient } from "@dfinity/auth-client";
    import { onMount } from "svelte";
    import { auth, createActor } from "../store/auth";
    import Button from "$lib/components/ui/button/button.svelte";
	import * as DropdownMenu from "$lib/components/ui/dropdown-menu/index.ts"; 
	import * as Avatar from "$lib/components/ui/avatar/index.ts";
	import * as Card from "$lib/components/ui/card/index"

	import { ethers } from 'ethers'

	let balance = 'N/A';
    let isConnected = false;

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

    function login() {
        client.login({
        identityProvider:
            process.env.DFX_NETWORK === "ic"
            ? "https://identity.ic0.app/#authorize"
            : `http://${process.env.CANISTER_ID_INTERNET_IDENTITY}.localhost:4943/#authorize`,
        onSuccess: handleAuth,
        });
    }

    async function logout() {
        await client.logout();
        auth.update(() => ({
        loggedIn: false,
        actor: createActor(),
        }));

        whoami = $auth.actor.whoami();
    }

	let canisterId = process.env.CANISTER_ID_HACK_FRONTEND

	async function connectWallet() {
        if (window.ethereum) {
            try {
                const provider = new ethers.providers.Web3Provider(window.ethereum);
                await provider.send("eth_requestAccounts", []);
                const signer = provider.getSigner();
				console.log("The signer is: ", signer)
                // const address = await signer.getAddress();
				// console.log("The adress is: ", address)
                // await updateBalance(address);
                // isConnected = true;
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

</script>

<div class="hidden flex-col md:flex">
	<div class="border-b">
		<div class="flex h-16 items-center px-4">
			<nav class="flex items-center space-x-4 lg:space-x-6">
				<a 
					href='/?canisterId={canisterId}'
					class="text-sm font-medium text-muted-foreground transition-colors hover:text-primary"
				>
					
					Overview
				</a>

				<a
					href="/faq?canisterId={canisterId}"
					class="text-sm font-medium text-muted-foreground transition-colors hover:text-primary"
				>
					FAQ
				</a>
				<a
					href="/about?canisterId={canisterId}"
					class="text-sm font-medium text-muted-foreground transition-colors hover:text-primary"
				>
					Reports
				</a>
				<!-- {#if session}
					<a
						href="/dashboard"
						class="text-sm font-medium text-muted-foreground transition-colors hover:text-primary"
					>
						Dashboard
					</a>
				{/if} -->
			</nav>
			<div class="ml-auto flex items-center space-x-4">
				<div>Wallet Balance: {balance} ETH</div>
				{#if $auth.loggedIn}
					<DropdownMenu.Root>
						<DropdownMenu.Trigger asChild let:builder>
							<Button variant="ghost" builders={[builder]} class="relative h-8 w-8 rounded-full">
								<Avatar.Root class="h-8 w-8">
									<Avatar.Fallback>
										AS
										<!-- {session?.user.user_metadata.name 
											? session.user.user_metadata.name[0] 
											: (session?.user.user_metadata.first_name[0] + (session?.user.user_metadata.last_name ? session.user.user_metadata.last_name[0] : ''))
										} -->
									</Avatar.Fallback>
								</Avatar.Root>
							</Button>
						</DropdownMenu.Trigger>
						<DropdownMenu.Content class="w-56" align="end">
							<DropdownMenu.Label class="font-normal">
								<div class="flex flex-col space-y-1">
									<p class="text-sm font-medium leading-none">
										{#await whoami}
											Querying caller identity...
										{:then principal}
											Your principal ID is
											<code>{principal}</code>

											{#if principal.isAnonymous()}
												(anonymous)
											{/if}
										{/await}
										Name and Surname
										<!-- {session?.user.user_metadata.name 
											? session.user.user_metadata.name[0] 
											: (session?.user.user_metadata.first_name[0] + (session?.user.user_metadata.last_name ? session.user.user_metadata.last_name[0] : ''))
										} -->
									</p>
									<p class="text-xs leading-none text-muted-foreground">Name</p>
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
							<DropdownMenu.Item on:click={logout}>
								Log out
								<DropdownMenu.Shortcut>⇧⌘Q</DropdownMenu.Shortcut>
							</DropdownMenu.Item>
						</DropdownMenu.Content>
					</DropdownMenu.Root>
                {:else}
                    <Button on:click={login}>Log in</Button>

					<Button on:click={connectWallet} disabled={isConnected}>Connect Wallet</Button>
                {/if}
			</div>
		</div>
	</div>
</div>		



<slot></slot>
