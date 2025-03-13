<template>
	<div
		class="bingo-tile"
		:class="`bingo-tile_state-${state}`"
		ref="tile"
		@click="updateState"
	>
		{{ model }}
	</div>
</template>
<script lang="ts" setup>
import { onMounted, ref, useTemplateRef, watch } from "vue";
const model = defineModel<string>();
const state = ref(0);
const tile = useTemplateRef("tile");

const resizeText = () => {
	const element = tile.value;
	if (!element) return;

	const parentWidth = element.clientWidth;
	const parentHeight = element.clientHeight;
	let fontSize = 24; // Initial font size
	element.style.fontSize = `${fontSize}px`;

	while (
		element.scrollWidth > parentWidth ||
		element.scrollHeight > parentHeight
	) {
		fontSize -= 1;
		element.style.fontSize = `${fontSize}px`;
		if (fontSize <= 0) break;
	}
};

const sizeObserver = new ResizeObserver(resizeText);
onMounted(() => {
	if (tile.value) {
		sizeObserver.observe(tile.value);
	}
});

const updateState = () => {
	state.value = (state.value + 1) % 3;
};

onMounted(resizeText);
watch(
	() => model.value,
	() => {
		nextTick(resizeText);
		state.value = 0;
	}
);
</script>
<style scoped>
.bingo-tile {
	aspect-ratio: 1/1;
	border: 1px solid black;
	display: flex;
	justify-content: center;
	align-items: center;
	border: 1px solid black;
	text-align: center;
	padding: 4px;
	font-size: 24px;
	overflow: hidden;
	min-width: 0;
	max-width: 100%;
	color: black;
}

.bingo-tile_state-0 {
	background-color: white;
}

.bingo-tile_state-1 {
	background-color: green;
}

.bingo-tile_state-2 {
	background-color: red;
}
</style>
