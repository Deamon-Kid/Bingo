<template>
	<v-dialog v-model="model" max-width="500">
		<v-card>
			<v-card-title class="pa-0">
				<v-toolbar class="pl-4" density="compact">
					<span>
						Share [<span> {{ props.data.name }} </span>]
					</span>
					<v-spacer />
					<v-btn
						icon="mdi-close"
						rounded="0"
						class="mr-0"
						@click="() => (model = false)"
					/>
				</v-toolbar>
			</v-card-title>
			<v-card-text class="pb-0">
				<v-textarea :value="text" readonly dense hide-details />
			</v-card-text>
			<v-card-actions>
				<v-btn
					prepend-icon="mdi-content-copy"
					@click="copyText"
					color="primary"
				>
					Copy to Clipboard
				</v-btn>
			</v-card-actions>
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

const copyText = () => {
	window.navigator.clipboard.writeText(text.value);
};

window.console.error(model, props.data);
</script>
<style scoped></style>
