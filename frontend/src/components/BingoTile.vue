<template>
	<v-card
		class="bingo-tile"
		:class="`bingo-tile_state-${state}`"
		@click="updateState"
	>
		<div ref="tile">
			{{ model }}
		</div>
	</v-card>
</template>
<script lang="ts" setup>
import { onMounted, ref, useTemplateRef, watch } from "vue";
const model = defineModel<string>();
const state = ref(0);
const tile = useTemplateRef("tile");

const resizeText = () => {
	const element = tile.value;
	const parent = element?.parentElement;
	if (!element || !parent) return;

	let fontSize = 24; // Initial font size
	element.style.fontSize = `${fontSize}px`;
	element.style.maxHeight = `${element.clientWidth}px`;

	if (model.value == "Lebensgefährlich") {
		window.console.error(
			model.value,
			element.scrollWidth,
			element.clientWidth,
			element.offsetWidth
		);
	}

	while (
		element.scrollWidth != element.clientWidth ||
		element.scrollHeight != element.clientHeight ||
		element.scrollHeight != element.scrollWidth
	) {
		fontSize -= 1;
		element.style.fontSize = `${fontSize}px`;
		if (fontSize <= 8) break;
	}

	if (
		element.scrollWidth != element.clientWidth ||
		element.scrollHeight != element.clientHeight
	) {
		element.style.overflowWrap = "anywhere";
	} else {
		element.style.overflowWrap = "unset";
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
	border: 1px solid black;
	font-size: 24px;
	overflow: unset !important;
	min-width: 0;
	overflow: hidden;
	color: black;
	cursor: pointer;
	display: block;

	& > div {
		padding: 4px;
		text-align: center;
		display: flex;
		justify-content: center;
		align-items: center;
		aspect-ratio: 1/1;
		overflow: hidden;
		overflow-wrap: initial;
		width: 100%;
		max-width: 100%;
		line-height: 1em;
	}
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
