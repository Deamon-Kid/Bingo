<template>
	<v-footer height="40" app>
		<a
			v-for="item in items"
			:key="item.title"
			:href="item.href"
			:title="item.title"
			class="d-inline-block mx-2 social-link"
			rel="noopener noreferrer"
			target="_blank"
		>
			<v-icon :icon="item.icon" :size="16" />
		</a>

		<div
			class="text-caption text-disabled"
			style="position: absolute; right: 16px"
		>
			&copy; 2025-{{ new Date().getFullYear() }}
			<span class="d-none d-sm-inline-block">Moritz Beußel</span>
		</div>
	</v-footer>
</template>

<script setup lang="ts">
const items = [
	{
		title: "Homepage",
		icon: "mdi-home",
		href: "http://beussel.de",
	},
	{
		title: "Bingo GitHub",
		icon: `mdi-github`,
		href: "https://github.com/Deamon-Kid/Bingo/tree/feature/vue3",
	},
];
</script>

<style scoped lang="sass">
.social-link :deep(.v-icon)
  color: rgba(var(--v-theme-on-background), var(--v-disabled-opacity))
  text-decoration: none
  transition: .2s ease-in-out

  &:hover
    color: rgba(25, 118, 210, 1)
</style>
