<template>
	<v-app-bar density="compact" class="mx-0">
		<v-spacer v-if="!mobile" />
		<v-app-bar-title :title="props.bingoName">
			{{ props.bingoName || "unnamed Bingo" }}
		</v-app-bar-title>
		<v-spacer />
		<template #append>
			<template v-if="!mobile">
				<v-btn
					v-for="button in buttons"
					:key="button.title"
					variant="tonal"
					rounded="0"
					:icon="button.icon"
					:color="button.color"
					:title="button.title"
					@click="emit(`click:${button.title.toLowerCase()}`)"
				/>
			</template>
			<v-menu v-else>
				<template #activator="{ props }">
					<v-btn
						v-bind="props"
						variant="tonal"
						rounded="0"
						icon="mdi-cogs"
						color="grey"
					/>
				</template>
				<v-card width="200px">
					<v-list density="compact" elevation="0">
						<v-list-item
							v-for="button in buttons"
							:key="button.title"
							@click="emit(`click:${button.title.toLowerCase()}`)"
						>
							<template #prepend>
								<v-icon
									variant="text"
									rounded="0"
									:icon="button.icon"
									:color="button.color"
									size="sm"
								/>
							</template>
							<v-list-item-title>
								{{ button.title }}
							</v-list-item-title>
						</v-list-item>
					</v-list>
				</v-card>
			</v-menu>
		</template>
	</v-app-bar>
</template>
<script lang="ts">
type ButtonProps = {
	icon: string;
	color: string;
	title: string;
};
const buttons: ButtonProps[] = [
	{
		icon: "mdi-shuffle-variant",
		color: "primary",
		title: "Shuffle",
	},
	{
		icon: "mdi-cancel",
		color: "error",
		title: "Clear",
	},
	{
		icon: "mdi-share-variant",
		color: "success",
		title: "Share",
	},
	{
		icon: "mdi-pencil",
		color: "warning",
		title: "Edit",
	},
];
</script>
<script lang="ts" setup>
import { useDisplay } from "vuetify";

const { mobile } = useDisplay();
const props = defineProps({
	bingoName: {
		type: String,
		default: "unnamed Bingo",
	},
});

const emit = defineEmits(buttons.map((b) => "click:" + b.title.toLowerCase()));
</script>
<style scoped></style>
