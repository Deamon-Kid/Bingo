<template>
	<v-dialog v-model="model" max-width="500">
		<v-card>
			<v-card-title>
				<v-btn icon="mdi-close" @click="() => (model = false)" />
				Share Bingo
			</v-card-title>
			<v-card-text>
				<!-- <v-switch label="send Seed" v-model="sendSeed" /> -->
				<v-textarea :value="text" readonly dense />
			</v-card-text>
		</v-card>
	</v-dialog>
</template>
<script lang="ts" setup>
import type { Bingo } from "@/types/Bingo";

const route = useRoute();
const model = defineModel<boolean>();
const props = defineProps({
	data: {
		type: Object as PropType<Bingo>,
		required: true,
	},
});

const sendSeed = ref(true);

const text = computed(() => {
	return window.location.href;
});

window.console.error(model, props.data);
</script>
<style scoped></style>
