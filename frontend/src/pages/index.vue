<template>
	<title-bar
		:bingo-name="bingo.name"
		@click:shuffle="updateSeed"
		@click:clear="clearState"
		@click:edit="showEditDialog = true"
		@click:share="showSaveDialog = true"
	/>
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
import { useRoute, type LocationQueryValue } from "vue-router";
import type { Bingo } from "@/types/Bingo";
import { useTheme } from "vuetify";
import type { BingoEntry } from "@/types/BingoEntry";

const route = useRoute();
const theme = useTheme();

const loadFields = () => {
	if (route.query.fields) {
		return (
			(route.query.fields as LocationQueryValue)
				?.split("|")
				.map((value: string) => {
					return {
						value: value.substring(1),
						free: value.startsWith("1"),
					} as BingoEntry;
				}) || []
		);
	}
	let fields = route.query["f[]"];
	if (!Array.isArray(fields)) {
		fields = [fields];
	}
	return (
		fields
			.filter((value) => value != null && value.length > 0)
			.map(
				(value) =>
					({
						value: value?.substring(1),
						free: value?.startsWith("1"),
					} as BingoEntry)
			) || []
	);
};

const seed = ref(
	route.query.seed?.toString() ?? Math.random().toString(36).substring(7)
);
const bingo: Ref<Bingo> = ref({
	name: route.query.name?.toString() || "",
	fields: loadFields(),
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
	bingo.value.fields.forEach((f) => {
		query.append("f[]", `${f.free ? 1 : 0}${f.value}`);
	});
	if (bingo.value.freeCenter) {
		query.set("freeCenter", "1");
	}
	if (bingo.value.freeAnywhere) {
		query.set("freeAnywhere", "1");
	}
	query.set("size", bingo.value.size.toString());
	history.replaceState(null, "", `?${query.toString()}`);
};

const updateSeed = () => {
	seed.value = Math.random().toString(36).substring(7);
	clearState();
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

if (window.localStorage.getItem("state")) {
	state.value = JSON.parse(window.localStorage.getItem("state") || "[]");
} else {
	state.value = new Array(bingo.value.size ** 2).fill(0);
}
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
