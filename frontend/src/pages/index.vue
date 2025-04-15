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
				icon="mdi-share-variant"
				color="success"
				@click="() => (showSaveDialog = true)"
			/>
			<v-btn
				variant="tonal"
				rounded="0"
				icon="mdi-pencil"
				color="warning"
				@click="() => (showEditDialog = !showEditDialog)"
			/>
		</div>
	</v-app-bar>
	<div class="bingo-container">
		<bingo-board class="mx-auto" :data="bingo" :seed="seed" />
	</div>
	<edit-dialog v-model="showEditDialog" v-model:data="bingo" />
	<save-dialog v-if="showSaveDialog" v-model="showSaveDialog" :data="bingo" />
</template>
<script lang="ts" setup>
import { ref, type Ref } from "vue";
import BingoBoard from "../components/BingoBoard.vue";
import SaveDialog from "@/components/SaveDialog.vue";
import { useRoute } from "vue-router";
import type { Bingo } from "@/types/Bingo";

const route = useRoute();
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
const showSaveDialog = ref(false);
const showEditDialog = ref(false);
const bingoName = computed(() => bingo.value.name || "unnamed Bingo");

watch(
	bingo,
	(val) => {
		const query = new URLSearchParams();
		query.set("name", val.name);
		query.set("seed", val.seed);
		query.set(
			"fields",
			val.fields.map((f) => (f.free ? "1" : "0") + f.value).join("|")
		);
		if (val.freeCenter) {
			query.set("freeCenter", "1");
		}
		if (val.freeAnywhere) {
			query.set("freeAnywhere", "1");
		}
		query.set("size", val.size.toString());
		history.replaceState(null, "", `?${query.toString()}`);
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
