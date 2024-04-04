declare namespace TaskQueue {
	interface Constructor {
		new <T>(onFlush: (items: T[]) => void): TaskQueue<T>;
	}
}

interface TaskQueue<T> {
	Add(item: T): void;

	Clear(): void;

	Destroy(): void;
}

declare const TaskQueue: TaskQueue.Constructor;

export = TaskQueue;
