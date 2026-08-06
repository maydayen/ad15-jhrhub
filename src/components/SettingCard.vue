<template>
  <div class="setting-card">
    <div>
      <h4>{{ title }}</h4>
      <p>{{ desc }}</p>
    </div>
    <button :class="{ danger: danger }">{{ action }}</button>
  </div>
</template>

<script setup>
defineProps({
  title: String,
  desc: String,
  action: String,
  danger: Boolean
})
</script>