<template>
	<v-app-bar density="compact">
		<h2 class="ml-4">
			{{ bingo.name || "unnamed Bingo" }}
		</h2>
		<v-spacer />
		<div>
			<v-btn
				@click="
					() => (bingo.seed = Math.random().toString(36).substring(7))
				"
				variant="tonal"
				rounded="0"
				icon="mdi-shuffle-variant"
			/>
			<v-btn
				@click="() => (showSaveDialog = true)"
				variant="tonal"
				rounded="0"
				icon="mdi-share-variant"
			/>
			<v-btn
				@click="() => (showEditDialog = !showEditDialog)"
				variant="tonal"
				rounded="0"
				icon="mdi-pencil"
				:color="showEditDialog ? 'error' : ''"
			/>
		</div>
	</v-app-bar>
	<div class="bingo-container">
		<bingo-board
			class="mx-auto"
			:size="bingo.size"
			:fields="bingo.fields"
			:seed="bingo.seed"
		/>
	</div>
	<edit-dialog v-model="showEditDialog" v-model:data="bingo" />
	<save-dialog v-if="showSaveDialog" v-model="showSaveDialog" :data="bingo" />
	<router-view />
</template>
<script lang="ts" setup>
import { ref, type Ref } from "vue";
import BingoBoard from "../components/BingoBoard.vue";
import SaveDialog from "@/components/SaveDialog.vue";
import { useRoute } from "vue-router";
import type { Bingo } from "@/types/Bingo";

const route = useRoute();
const bingo: Ref<Bingo> = ref({
	name: route.query.name?.toString() || "",
	seed:
		route.query.seed?.toString() || Math.random().toString(36).substring(7),
	fields:
		route.query.fields
			?.toString()
			.split(",")
			.map((value) => ({
				value: value.substring(1),
				free: value.startsWith("1"),
			})) || [],
	size: parseInt(route.query.size?.toString() || "3") || 3,
});
const showSaveDialog = ref(false);
const showEditDialog = ref(false);

watch(
	bingo,
	(val) => {
		const query = new URLSearchParams();
		query.set("name", val.name);
		query.set("seed", val.seed);
		query.set(
			"fields",
			val.fields.map((f) => (f.free ? "1" : "0") + f.value).join(",")
		);
		query.set("size", val.size.toString());
		history.replaceState(null, "", `?${query.toString()}`);
	},
	{ deep: true }
);
</script>
<style scoped>
.bingo-container {
	max-width: 750px;
	margin: 0px auto;
	max-height: calc(100vh -1000px);
}
</style>
