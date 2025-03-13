<template>
	<div class="ml-2">
		<div class="d-flex">
			<div class="mr-4 font-weight-bold">Free</div>
			<div class="flex-grow-1 font-weight-bold">Field</div>
			<div class="font-weight-bold">Delete</div>
		</div>
		<v-text-field
			v-for="(entry, i) in fields"
			:key="`entry-${i}`"
			type="text"
			v-model="entry.value"
			density="compact"
			hide-details
			placeholder="Insert Field"
			autofocus
			:tabindex="i + 1"
		>
			<template #prepend>
				<v-switch
					v-model="entry.free"
					title="free"
					density="compact"
					hide-details
				/>
			</template>
			<template #append>
				<v-btn
					@click="fields.splice(i, 1)"
					icon="mdi-delete"
					color="error"
					variant="plain"
					rounded="0"
				/>
			</template>
		</v-text-field>
		<v-btn
			@click="addEntry"
			prepend-icon="mdi-plus"
			:tabindex="fields.length"
		>
			Add Field
		</v-btn>
	</div>
</template>
<script lang="ts" setup>
import type { BingoEntry } from "@/types/BingoEntry";
import { ref, watch } from "vue";
import { defineProps } from "vue";

const props = defineProps({
	modelValue: {
		type: Array as () => BingoEntry[],
		required: true,
	},
});

const emit = defineEmits(["update:modelValue"]);

const fields = ref(props.modelValue);

watch(
	fields,
	() => {
		emit("update:modelValue", fields.value);
	},
	{ deep: true }
);

const addEntry = () => {
	fields.value.push({ value: "", free: false });
};
</script>
<style scoped></style>
