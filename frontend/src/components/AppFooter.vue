<template>
	<v-footer app height="40">
		<v-menu :close-on-content-click="false" location="top left">
			<template #activator="{ props }">
				<v-btn
					v-bind="props"
					icon="mdi-cog"
					variant="flat"
					rounded="0"
					height="40"
				/>
			</template>
			<v-list density="compact" elevation="0">
				<v-list-item density="compact">
					<v-switch
						id="theme-toggle"
						:model-value="isLightMode"
						hide-details
						density="compact"
						@update:model-value="(v) => toggleTheme(v as boolean)"
					>
						<template #label>
							<v-icon>mdi-weather-sunny</v-icon>
						</template>
						<template #prepend>
							<label for="theme-toggle">
								<v-icon>mdi-moon-new</v-icon>
							</label>
						</template>
					</v-switch>
				</v-list-item>
			</v-list>
		</v-menu>
		<v-spacer />
		<div class="text-caption text-disabled mr-2">
			&copy; 2025-{{ new Date().getFullYear() }}
			<span class="d-none d-sm-inline-block">Moritz Beußel</span>
		</div>
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
	</v-footer>
</template>

<script setup lang="ts">
import { useTheme } from "vuetify";

const theme = useTheme();
const items = [
	{
		title: "Homepage",
		icon: "mdi-home",
		href: "https://www.beussel.de",
	},
	{
		title: "Bingo GitHub",
		icon: `mdi-github`,
		href: "https://github.com/Deamon-Kid/Bingo/tree/feature/vue3",
	},
];

const isLightMode = computed(() => {
	return theme.global.name.value !== "dark";
});

const toggleTheme = (value: boolean) => {
	const mode = value ? "light" : "dark";
	theme.global.name.value = mode;
	window.localStorage.setItem("theme", mode);
};
</script>

<style scoped lang="sass">
.social-link :deep(.v-icon)
  color: rgba(var(--v-theme-on-background), var(--v-disabled-opacity))
  text-decoration: none
  transition: .2s ease-in-out

  &:hover
    color: rgba(25, 118, 210, 1)
</style>
