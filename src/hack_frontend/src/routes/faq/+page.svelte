<script>
    import * as Accordion from "$lib/components/ui/accordion/index.ts"; 
</script>


<Accordion.Root class="w-full sm:max-w-[70%]">
    <Accordion.Item value="item-1">
        <Accordion.Trigger>Stop</Accordion.Trigger>
        <Accordion.Content
            >Why are you looking here?</Accordion.Content
        >
    </Accordion.Item>
    <Accordion.Item value="item-2">
        <Accordion.Trigger>Chill</Accordion.Trigger>
        <Accordion.Content>
            Nothing here yet, give me a minute
        </Accordion.Content>
    </Accordion.Item>
    <Accordion.Item value="item-3">
        <Accordion.Trigger>Funny</Accordion.Trigger>
        <Accordion.Content>
            Yeah I don't know many jokes so we will need to outsource that.
        </Accordion.Content>
    </Accordion.Item>
</Accordion.Root>
  
  