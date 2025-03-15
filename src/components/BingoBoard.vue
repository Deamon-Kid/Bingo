<template>
	<div
		class="bingo-board"
		:style="`grid-template-columns: repeat(${size}, 1fr)`"
	>
		<bingo-tile
			v-for="(field, i) in board"
			:key="`board-${i}`"
			:model-value="field"
		/>
	</div>
</template>

<script setup lang="ts">
import type { BingoEntry } from "@/types/BingoEntry";
import BingoTile from "./BingoTile.vue";
import { computed } from "vue";
import seedrandom from "seedrandom";

const props = defineProps({
	size: {
		type: Number,
		required: true,
	},
	fields: {
		type: Array<BingoEntry>,
		required: false,
		default: [],
	},
	seed: {
		type: String,
		required: false,
		default: () => Math.random().toString(),
	},
});

const board = computed(() => {
	let result = new Array(props.size ** 2).fill("");
	const rng = seedrandom(props.seed);
	const tiles = [...props.fields.filter((f) => !f.free).map((f) => f.value)];
	tiles.sort(() => rng() - 0.5);
	result = result.map((_, i) => tiles[i]);
	const freeTiles = props.fields.filter((f) => f.free).map((f) => f.value);
	if (freeTiles.length > 0) {
		const centerIndex = Math.floor(props.size ** 2 / 2);
		if (tiles.length < props.size ** 2) {
			result[tiles.length] = tiles[centerIndex];
		}
		result[centerIndex] = freeTiles.sort(() => rng() - 0.5)?.[0] || "Free";
	}
	return result;
});
</script>

<style scoped>
.bingo-board {
	max-width: minmax(100%, var(--grid-size));
	width: minmax(100%, var(--grid-size));
	aspect-ratio: 1/1;
	display: grid;
	gap: 4px;
	margin: 4px;
}
</style>
