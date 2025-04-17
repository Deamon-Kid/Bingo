<template>
	<v-app-bar density="compact">
		<v-spacer />
		<h2
			class="ml-4 bingo-title flex-shrink-1 flex-grow-0 d-block"
			:title="bingoName"
		>
			{{ bingoName }}
		</h2>
		<v-spacer />
		<div class="flex-grow-1 flex-shrink-0">
			<v-btn
				variant="tonal"
				rounded="0"
				icon="mdi-shuffle-variant"
				color="primary"
				@click="() => (seed = Math.random().toString(36).substring(7))"
			/>
			<v-btn
				variant="tonal"
				rounded="0"
				icon="mdi-cancel"
				color="error"
				@click="clearState"
			/>
			<v-menu>
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
						<v-list-item @click="() => (showSaveDialog = true)">
							<template #prepend>
								<v-icon
									variant="text"
									rounded="0"
									icon="mdi-share-variant"
									color="success"
									size="sm"
								/>
							</template>
							<v-list-item-title> Share </v-list-item-title>
						</v-list-item>
						<v-list-item
							@click="() => (showEditDialog = !showEditDialog)"
						>
							<template #prepend>
								<v-icon
									variant="text"
									rounded="0"
									icon="mdi-pencil"
									color="warning"
									size="sm"
								/>
							</template>
							<v-list-item-title> Edit </v-list-item-title>
						</v-list-item>
					</v-list>
				</v-card>
			</v-menu>
		</div>
	</v-app-bar>
	<div class="bingo-container">
		<bingo-board
			class="mx-auto"
			v-model:state="state"
			:data="bingo"
			:seed="seed"
		/>
	</div>
	<edit-dialog v-model="showEditDialog" v-model:data="bingo" />
	<save-dialog v-if="showSaveDialog" v-model="showSaveDialog" :data="bingo" />
</template>
<script lang="ts" setup>
import { ref, type Ref } from "vue";
import BingoBoard from "../components/BingoBoard.vue";
import SaveDialog from "@/components/ShareDialog.vue";
import { useRoute } from "vue-router";
import type { Bingo } from "@/types/Bingo";
import { useTheme } from "vuetify";

const route = useRoute();
const theme = useTheme();
const seed = ref(
	route.query.seed?.toString() ?? Math.random().toString(36).substring(7)
);
const bingo: Ref<Bingo> = ref({
	name: route.query.name?.toString() || "",
	fields:
		route.query.fields
			?.toString()
			.split("|")
			.filter((value) => value.length > 0)
			.map((value) => ({
				value: value.substring(1),
				free: value.startsWith("1"),
			})) || [],
	size: parseInt(route.query.size?.toString() || "3"),
	freeCenter: !!route.query.freeCenter,
	freeAnywhere: !!route.query.freeAnywhere,
});
const state: Ref<number[]> = ref([]);
const showSaveDialog = ref(false);
const showEditDialog = ref(false);
const bingoName = computed(() => bingo.value.name || "unnamed Bingo");

const updateUrl = () => {
	const query = new URLSearchParams();
	query.set("name", bingo.value.name);
	query.set("seed", seed.value);
	query.set(
		"fields",
		bingo.value.fields.map((f) => (f.free ? "1" : "0") + f.value).join("|")
	);
	if (bingo.value.freeCenter) {
		query.set("freeCenter", "1");
	}
	if (bingo.value.freeAnywhere) {
		query.set("freeAnywhere", "1");
	}
	query.set("size", bingo.value.size.toString());
	history.replaceState(null, "", `?${query.toString()}`);
};

const clearState = () => {
	state.value = new Array(bingo.value.size ** 2).fill(0);
};

const currentTheme = window.localStorage.getItem("theme");
if (currentTheme !== null) {
	theme.global.name.value = currentTheme;
}

watch(
	bingo,
	() => {
		updateUrl();
	},
	{ deep: true }
);

watch(
	seed,
	(val) => {
		updateUrl();
		if (window.localStorage.getItem("state")) {
			state.value = JSON.parse(
				window.localStorage.getItem("state") || "[]"
			);
		} else {
			state.value = new Array(bingo.value.size ** 2).fill(0);
		}
		window.localStorage.setItem("seed", val);
	},
	{ immediate: true }
);

watch(
	() => state,
	() => {
		window.localStorage.setItem("state", JSON.stringify(state.value));
	},
	{ deep: true }
);
</script>
<style scoped>
.bingo-title {
	overflow: hidden;
	text-overflow: ellipsis;
	white-space: nowrap;
}
.bingo-container {
	max-width: min(calc(100vw - 10px), calc(100vh - 100px));
	margin: 0px auto;
	max-height: calc(100vh -1000px);
}
</style>
