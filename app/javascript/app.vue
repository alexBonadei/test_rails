<template>
  <div id="app">
    <button @click="toggleModal">Filter</button>
    <modal name="input-modal" v-if="isModalOpen">
      <div class="modal-content">
        <form @submit.prevent="submitForm" v-if="isModalOpen">
          <label for="term">Term:</label>
          <input type="text" v-model="term" id="term" required>
          <button type="submit">Submit</button>
        </form>
      </div>
    </modal>
    <post v-for="post in posts" :key="post.id" :post="post"></post>
    <p v-if="posts.length === 0">No posts found!</p>
  </div>
</template>

<script>
import Post from './components/Post'

export default {
  components: { Post },

  data() {
    return {
      posts: [],
      term: '',
      isModalOpen: false
    }
  },

  methods: {
    toggleModal() {
      this.isModalOpen = !this.isModalOpen;
    },

    submitForm() {
      console.log('Form submitted with term:', this.term);
      fetch(`/api/posts/search?term=${encodeURIComponent(this.term)}`)
        .then(response => response.json())
        .then(data => {
          this.posts = data;
        })
        .catch(error => {
          console.error('Error fetching search results:', error);
        });
    },

    fetchPosts() {
      fetch('/api/posts')
        .then(response => response.json())
        .then(data => {
          this.posts = data;
        })
        .catch(error => {
          console.error('Error fetching posts:', error);
        });
    }
  },

  mounted() {
    this.fetchPosts();
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
