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
	if (!element) return;

	let fontSize = 24; // Initial font size
	element.style.fontSize = `${fontSize}px`;

	while (element.scrollWidth != element.scrollHeight) {
		fontSize -= 1;
		element.style.fontSize = `${fontSize}px`;
		if (fontSize <= 8) break;
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
	padding: 4px;
	font-size: 24px;
	overflow: unset !important;
	overflow-y: auto;
	min-width: 0;
	max-width: 100%;
	max-height: 100%;
	color: black;
	cursor: pointer;

	& > div {
		text-align: center;
		display: flex;
		justify-content: center;
		align-items: center;
		aspect-ratio: 1/1;
		overflow: initial;
		overflow-wrap: initial;
		width: 100%;
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
