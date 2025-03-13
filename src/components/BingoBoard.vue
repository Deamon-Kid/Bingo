<template>
	<div class="bingo-board" :class="`bingo-board--size-${size}`">
		<v-card
			v-for="(field, i) in board"
			:key="`board-${i}`"
			class="bingo-field"
		>
			<bingo-tile :model-value="field" />
		</v-card>
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
	window.console.error("generating field", props.seed);
	let result = new Array(props.size ** 2).fill("");
	const rng = seedrandom(props.seed);
	window.console.error(rng() - 0.5, rng() - 0.5, rng() - 0.5, rng() - 0.5);
	const tiles = [...props.fields.filter((f) => !f.free).map((f) => f.value)];
	tiles.sort(() => rng() - 0.5);
	//   if (tiles.length >= props.size ** 2) {
	result = result.map((_, i) => tiles[i]);
	//   }
	if (tiles.length < props.size ** 2) {
		const centerIndex = Math.floor(props.size ** 2 / 2);
		result[tiles.length] = tiles[centerIndex];
		const freeTiles = props.fields
			.filter((f) => f.free)
			.map((f) => f.value);
		result[centerIndex] = freeTiles.sort(() => rng() - 0.5)?.[0] || "Free";
	}
	return result;
});
</script>

<style scoped>
.bingo-board {
	max-width: 500px;
	width: 500px;
	aspect-ratio: 1/1;
	display: grid;
	gap: 4px;
	margin: 4px;
}

.bingo-board--size-3 {
	grid-template-columns: repeat(3, 1fr);
	.bingo-field {
		width: calc(500px / 3);
	}
}

.bingo-board--size-5 {
	grid-template-columns: repeat(5, 1fr);
	.bingo-field {
		width: calc(500px / 5);
	}
}
</style>
