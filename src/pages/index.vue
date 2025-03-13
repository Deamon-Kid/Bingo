<template>
	<v-card class="d-flex">
		<v-text-field
			hideDetails
			singleLine
			placeholder="BingoName"
			v-model="bingo.name"
			density="compact"
		/>
		<div>
			<v-btn
				@click="
					() => (bingo.seed = Math.random().toString(36).substring(7))
				"
				variant="tonal"
				rounded="0"
				icon="mdi-shuffle-variant"
			/>
			<v-btn
				@click="() => (showDialog = true)"
				variant="tonal"
				rounded="0"
				icon="mdi-share-variant"
			/>
			<v-btn
				@click="() => (edit = !edit)"
				variant="tonal"
				rounded="0"
				icon="mdi-pencil"
				:color="edit ? 'error' : ''"
			/>
		</div>
	</v-card>
	<v-container>
		<v-row>
			<v-col v-if="edit" xs="12" md="auto">
				<v-select
					v-if="edit"
					v-model="bingo.size"
					size="1"
					:items="[3, 5]"
					label="Field Size"
					hide-details
				/>
				<v-alert
					v-if="!valid"
					type="warning"
					class="mx-2"
					density="compact"
				>
					Not enough fields to create a valid bingo board
				</v-alert>
				<bingo-entry :modelValue="bingo.fields" />
			</v-col>
			<v-col xs="12" md="auto">
				<bingo-board
					class="mx-auto"
					:size="bingo.size"
					:fields="bingo.fields"
					:seed="bingo.seed"
				/>
			</v-col>
		</v-row>
	</v-container>
	<save-dialog v-if="showDialog" v-model="showDialog" :data="bingo" />
	<router-view />
</template>
<script lang="ts" setup>
import { ref, type Ref } from "vue";
import BingoBoard from "../components/BingoBoard.vue";
import BingoEntry from "@/components/BingoEntry.vue";
import SaveDialog from "@/components/SaveDialog.vue";
import { useRoute } from "vue-router";
import type { Bingo } from "@/types/Bingo";

const route = useRoute();
const bingo: Ref<Bingo> = ref({
	name: route.query.name?.toString() || "",
	seed:
		route.query.seed?.toString() || Math.random().toString(36).substring(7),
	fields:
		route.query.fields
			?.toString()
			.split(",")
			.map((value) => ({
				value: value.substring(1),
				free: value.startsWith("1"),
			})) || [],
	size: parseInt(route.query.size?.toString() || "3") || 3,
});
const showDialog = ref(false);
const edit = ref(false);
const valid = computed(() => {
	const locked = bingo.value.fields.filter((f) => !f.free);
	const squareSize = bingo.value.size * bingo.value.size;
	return (
		locked.length >= squareSize ||
		(locked.length == squareSize - 1 &&
			bingo.value.fields.some((f) => f.free))
	);
});

watch(
	bingo,
	(val) => {
		const query = new URLSearchParams();
		query.set("name", val.name);
		query.set("seed", val.seed);
		query.set(
			"fields",
			val.fields.map((f) => (f.free ? "1" : "0") + f.value).join(",")
		);
		query.set("size", val.size.toString());
		history.replaceState(null, "", `?${query.toString()}`);
	},
	{ deep: true }
);
</script>
<style scoped></style>
