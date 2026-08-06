<template>
  <div class="stat-card">
    <span>{{ label }}</span>
    <strong>{{ value }}</strong>
    <p>{{ note }}</p>
  </div>
</template>

<script setup>
defineProps({
  label: String,
  value: String,
  note: String
})
</script>