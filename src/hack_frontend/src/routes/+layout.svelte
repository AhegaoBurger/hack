<!-- src/hack_frontend/src/routes/+Layout.svelte -->
<script>
    import "../app.pcss";

    import Button from "$lib/components/ui/button/button.svelte";
	import * as DropdownMenu from "$lib/components/ui/dropdown-menu/index.ts"; 
	import * as Avatar from "$lib/components/ui/avatar/index.ts";
	import * as Card from "$lib/components/ui/card/index"

	import { ethers } from 'ethers';

	let balance = 'N/A';
	let MetaMaskAdress;
    let isConnected = false;

	let canisterId = process.env.CANISTER_ID_HACK_FRONTEND

	async function connectWallet() {
        if (window.ethereum) {
            try {
                const provider = new ethers.providers.Web3Provider(window.ethereum);
                await provider.send("eth_requestAccounts", []);
                const signer = provider.getSigner();
				console.log("The signer is: ", signer)
                const address = await signer.getAddress();
				MetaMaskAdress = address;
				console.log("The adress is: ", address)
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

</script>

<section class="flex">
	<sidebar class="border-r">
		<div class="w-16 flex flex-col items-center py-4 space-y-4">
			<!-- Icons or logo -->
			<!-- Navigation Icons -->
			<div class="flex flex-col space-y-2">
				<!-- Replace with your actual icons -->
				<a href="/" class="p-2 hover:bg-gray-700 rounded-md"><img src="/favicon.ico" alt="Dashboard" class="w-6 h-6"></a>
				<a href="/" class="p-2 hover:bg-gray-700 rounded-md"><img src="/favicon.ico" alt="Dashboard" class="w-6 h-6"></a>
				<a href="/" class="p-2 hover:bg-gray-700 rounded-md"><img src="/favicon.ico" alt="Dashboard" class="w-6 h-6"></a>
				<a href="/setup?canisterId={canisterId}" class="p-2 hover:bg-gray-700 rounded-md"><img src="/plus-solid.svg" alt="Dashboard" class="w-6 h-6"></a>
				<!-- Add more navigation items here -->
			</div>
		</div>
	</sidebar>

	<section class="w-full">
		<div>
			<!-- Vertical Navbar -->
			
			<!-- Main Content -->
			<div class="border-b">
				<div class="flex-grow">
					<div class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
						<!-- Your content here -->
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
						</nav>
		
						<div class="ml-auto flex items-center space-x-4">
							<div>Wallet Balance: {balance} ETH</div>
								<DropdownMenu.Root>
									<DropdownMenu.Trigger asChild let:builder>
										<Button variant="ghost" builders={[builder]} class="relative h-8 w-8 rounded-full">
											<Avatar.Root class="h-8 w-8">
												<Avatar.Fallback>
													AS
												</Avatar.Fallback>
											</Avatar.Root>
										</Button>
									</DropdownMenu.Trigger>
									<DropdownMenu.Content class="w-56" align="end">
										<DropdownMenu.Label class="font-normal">
											<div class="flex flex-col space-y-1">
												<p class="text-sm font-medium leading-none">
													{#if MetaMaskAdress}
														{MetaMaskAdress}
													{/if}
													Name and Surname
												</p>
												<p class="text-xs leading-none text-muted-foreground">
													{#if MetaMaskAdress}
														{MetaMaskAdress}
													{/if}
													Name
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
										<DropdownMenu.Item on:click>
											Log out
											<DropdownMenu.Shortcut>⇧⌘Q</DropdownMenu.Shortcut>
										</DropdownMenu.Item>
									</DropdownMenu.Content>
								</DropdownMenu.Root>
		
								<Button on:click={connectWallet} disabled={isConnected}>Connect Wallet</Button>
						</div>
					</div>
				</div>
			</div>
		
			<!-- <div class="border-b">
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
					</nav>
					<div class="ml-auto flex items-center space-x-4">
						<div>Wallet Balance: {balance} ETH</div>
							<DropdownMenu.Root>
								<DropdownMenu.Trigger asChild let:builder>
									<Button variant="ghost" builders={[builder]} class="relative h-8 w-8 rounded-full">
										<Avatar.Root class="h-8 w-8">
											<Avatar.Fallback>
												AS
											</Avatar.Fallback>
										</Avatar.Root>
									</Button>
								</DropdownMenu.Trigger>
								<DropdownMenu.Content class="w-56" align="end">
									<DropdownMenu.Label class="font-normal">
										<div class="flex flex-col space-y-1">
											<p class="text-sm font-medium leading-none">
												{#if MetaMaskAdress}
													{MetaMaskAdress}
												{/if}
												Name and Surname
											</p>
											<p class="text-xs leading-none text-muted-foreground">
												{#if MetaMaskAdress}
													{MetaMaskAdress}
												{/if}
												Name
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
									<DropdownMenu.Item on:click>
										Log out
										<DropdownMenu.Shortcut>⇧⌘Q</DropdownMenu.Shortcut>
									</DropdownMenu.Item>
								</DropdownMenu.Content>
							</DropdownMenu.Root>
		
							<Button on:click={connectWallet} disabled={isConnected}>Connect Wallet</Button>
					</div>
				</div>
			</div> -->
			<!-- <slot /> -->
		</div>		
		
		<slot />
		</section>
		
</section>
