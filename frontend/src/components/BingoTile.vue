<template>
	<v-card
		class="bingo-tile"
		:class="`bingo-tile_state-${state}`"
		@click="updateState"
		:color="tileColor"
		:style="tileStyle"
	>
		<div>
			<span ref="tile">
				<slot> test </slot>
			</span>
		</div>
	</v-card>
</template>
<script lang="ts" setup>
import { onMounted, ref, useTemplateRef, watch } from "vue";
const state = defineModel<number>({ default: 0 });
const tile = useTemplateRef("tile");

const tileStyle = computed(() => {
	const t = tile.value?.parentElement;
	return {
		maxHeight: t?.clientWidth,
	};
});

const tileColor = computed(() => {
	switch (state.value) {
		case 1:
			return "green";
		case 2:
			return "red";
		default:
			return "white";
	}
});

const resizeText = () => {
	const element = tile.value;
	const parent = element?.parentElement;
	if (!element || !parent) return;

	let fontSize = 24; // Initial font size
	element.style.fontSize = `${fontSize}px`;
	element.style.overflowWrap = "unset";

	while (
		element.scrollWidth > parent.clientWidth ||
		element.scrollHeight > parent.clientHeight
	) {
		fontSize -= 1;
		element.style.fontSize = `${fontSize}px`;
		if (fontSize <= 8) break;
	}

	if (element.scrollWidth > parent.clientWidth) {
		element.style.overflowWrap = "anywhere";
	}
};

const sizeObserver = new ResizeObserver(resizeText);
onMounted(() => {
	if (tile.value) {
		sizeObserver.observe(tile.value);
	}
	nextTick(resizeText);
});

const updateState = () => {
	state.value = (state.value + 1) % 3;
};
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
	padding: 4px;

	& > div {
		text-align: center;
		display: flex;
		justify-content: center;
		align-items: center;
		aspect-ratio: 1/1;
		overflow: hidden;
		overflow-wrap: initial;
		width: 100%;
		& > span {
			line-height: 1em;
		}
	}
}
</style>
