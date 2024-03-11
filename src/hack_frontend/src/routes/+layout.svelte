<script>
    import "../app.pcss";

    import { AuthClient } from "@dfinity/auth-client";
    import { onMount } from "svelte";
    import { auth, createActor } from "../store/auth";
    import Button from "$lib/components/ui/button/button.svelte";
	import * as DropdownMenu from "$lib/components/ui/dropdown-menu/index.ts"; 
	import * as Avatar from "$lib/components/ui/avatar/index.ts";

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

</script>

<div class="hidden flex-col md:flex">
	<div class="border-b">
		<div class="flex h-16 items-center px-4">
			<nav class="flex items-center space-x-4 lg:space-x-6">
				<a href="/?canisterId=bd3sg-teaaa-aaaaa-qaaba-cai" class="text-sm font-medium transition-colors hover:text-primary">
					Overview
				</a>

				<a
					href="/faq?canisterId=bd3sg-teaaa-aaaaa-qaaba-cai"
					class="text-sm font-medium text-muted-foreground transition-colors hover:text-primary"
				>
					FAQ
				</a>
				<a
					href="/about?canisterId=bd3sg-teaaa-aaaaa-qaaba-cai"
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
                    <!-- <div>
                    <Button on:click={logout}>Log out</Button>
                    <button on:click={logout}>Log out</button>
                    </div> -->
                {:else}
					<!-- <a
						href="/login"
						class="text-sm font-medium text-muted-foreground transition-colors hover:text-primary"
					>
						Login
					</a> -->
                    <Button on:click={login}>Log in</Button>
                    <!-- <button on:click={login}>Authenticate in with Internet Identity</button> -->
                {/if}
			</div>
			<!-- <div class="ml-auto flex items-center space-x-4">
				{#if session}
					<DropdownMenu.Root>
						<DropdownMenu.Trigger asChild let:builder>
							<Button variant="ghost" builders={[builder]} class="relative h-8 w-8 rounded-full">
								<Avatar.Root class="h-8 w-8">
									<Avatar.Fallback>
										{session?.user.user_metadata.name 
											? session.user.user_metadata.name[0] 
											: (session?.user.user_metadata.first_name[0] + (session?.user.user_metadata.last_name ? session.user.user_metadata.last_name[0] : ''))
										}
									</Avatar.Fallback>
								</Avatar.Root>
							</Button>
						</DropdownMenu.Trigger>
						<DropdownMenu.Content class="w-56" align="end">
							<DropdownMenu.Label class="font-normal">
								<div class="flex flex-col space-y-1">
									<p class="text-sm font-medium leading-none">
										{session?.user.user_metadata.name 
											? session.user.user_metadata.name[0] 
											: (session?.user.user_metadata.first_name[0] + (session?.user.user_metadata.last_name ? session.user.user_metadata.last_name[0] : ''))
										}
									</p>
									<p class="text-xs leading-none text-muted-foreground">{session?.user.email}</p>
								</div>
							</DropdownMenu.Label>
							<DropdownMenu.Separator />
							<DropdownMenu.Group>
								<DropdownMenu.Item href="/settings">
									Profile
									<DropdownMenu.Shortcut>⇧⌘P</DropdownMenu.Shortcut>
								</DropdownMenu.Item>
								<DropdownMenu.Item href="billing">
									Billing
									<DropdownMenu.Shortcut>⌘B</DropdownMenu.Shortcut>
								</DropdownMenu.Item>
								<DropdownMenu.Item href="/settings">
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
					<a
						href="/login"
						class="text-sm font-medium text-muted-foreground transition-colors hover:text-primary"
					>
						Login
					</a>
				{/if}
			</div> -->
		</div>
	</div>
</div>		



<slot></slot>