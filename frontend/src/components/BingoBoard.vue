<template>
	<div
		class="bingo-board"
		:style="`grid-template-columns: repeat(${data.size}, 1fr)`"
	>
		<bingo-tile
			v-for="(field, i) in board"
			v-model="state[i]"
			:key="`board-${i}`"
		>
			{{ field ?? "" }}
		</bingo-tile>
	</div>
</template>

<script setup lang="ts">
import BingoTile from "./BingoTile.vue";
import { computed, watch } from "vue";
import seedrandom from "seedrandom";
import type { Bingo } from "@/types/Bingo";

const props = defineProps({
	data: {
		type: Object as PropType<Bingo>,
		required: true,
	},
	seed: {
		type: String,
		default: () => Math.random().toString(36).substring(7),
	},
});
const state: Ref<number[]> = ref([]);

const board = computed(() => {
	let result = new Array(props.data.size ** 2).fill({
		value: "",
		free: false,
	});
	let tiles = [...props.data.fields.filter((f) => !f.free)];
	const freeTiles = props.data.fields.filter((f) => f.free);
	if (props.data.freeAnywhere) {
		tiles = tiles.concat(freeTiles);
	}
	if (
		(!props.data.freeCenter && tiles.length < props.data.size ** 2) ||
		(freeTiles.length > 0 &&
			props.data.freeCenter &&
			tiles.length < props.data.size ** 2 - 1)
	) {
		return result.map((f) => f.value);
	}
	const rng = seedrandom(props.seed);
	tiles.sort(() => rng() - 0.5);
	result = result.map((_, i) => tiles[i]);
	if (props.data.freeCenter && freeTiles.length > 0) {
		const centerIndex = Math.floor(props.data.size ** 2 / 2);
		if (!freeTiles.includes(result[centerIndex])) {
			if (tiles.length < props.data.size ** 2) {
				result[tiles.length] = tiles[centerIndex];
			}
			const unusedFreeTiles = freeTiles.filter(
				(ft) => !result.includes(ft)
			);
			if (unusedFreeTiles.length > 0) {
				result[centerIndex] = unusedFreeTiles.sort(
					() => rng() - 0.5
				)[0];
			} else {
				const freeTileIndex = result.findIndex((ft) =>
					freeTiles.includes(ft)
				);
				const tmp = result[freeTileIndex];
				result[freeTileIndex] = result[centerIndex];
				result[centerIndex] = tmp;
			}
		}
	}
	return result.map((t) => t.value);
});

watch(
	() => props.seed,
	() => {
		state.value = new Array(props.data.size ** 2).fill(0);
	},
	{ immediate: true }
);
</script>

<style scoped>
.bingo-board {
	max-width: 100%;
	width: 100%;
	aspect-ratio: 1/1;
	display: grid;
	gap: 4px;
	margin: 4px;
}
</style>
