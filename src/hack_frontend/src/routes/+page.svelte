<script>
  import "../index.scss";
  import { backend } from "$lib/canisters";
  import Auth from "../components/Auth.svelte";
  import { Button } from '$lib/components/ui/button'
  import { Input } from '$lib/components/ui/input'

  let greeting = "";

  function onSubmit(event) {
    const name = event.target.name.value;
    backend.greet(name).then((response) => {
      greeting = response;
    });
    return false;
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
