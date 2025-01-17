package com.touchgrass.cah.server.service;

import org.springframework.stereotype.Service;

import java.util.Map;
import java.util.concurrent.*;
import java.util.concurrent.atomic.AtomicBoolean;

@Service
public class CleanUpService {

    private ScheduledExecutorService scheduler = Executors.newSingleThreadScheduledExecutor();
    private final PriorityBlockingQueue<LobbyWatcher> watcherQueue = new PriorityBlockingQueue<>();
    private final Map<String, LobbyWatcher> watcherMap = new ConcurrentHashMap<>();
    private CleanUpCallback cb;
    private final AtomicBoolean isSchedulerRunning = new AtomicBoolean(false);

    public void init(CleanUpCallback cb) {
        this.cb = cb; //TODO uncomment this
    }

    private void startScheduler() {
        scheduler.scheduleAtFixedRate(() -> {
            long now = System.currentTimeMillis();
            while (!watcherQueue.isEmpty()) {
                System.out.println("------------Checking afk lobbies");
                LobbyWatcher watcher = watcherQueue.peek();
                if (watcher.expirationTime() > now) {
                    break; // Stop if the soonest watcher hasn't expired
                }
                watcherQueue.poll();
                watcherMap.remove(watcher.id());
                System.out.println("------------Removing " + watcher.id);
                cb.onCleanUp(watcher.id());
            }

            // Stop scheduler if no lobbies are left
            if (watcherMap.isEmpty() && isSchedulerRunning.compareAndSet(true, false)) {
                stopScheduler();
            }
        }, 0, 10, TimeUnit.SECONDS); // Poll every 10 second
    }

    private void stopScheduler() {
        scheduler.shutdownNow();
        try {
            System.out.println("------------Thread is terminated ");
            scheduler.awaitTermination(1, TimeUnit.SECONDS);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }

    public void addWatcher(String id) {
        ensureSchedulerRunning();
        long expirationTime = System.currentTimeMillis() + TimeUnit.SECONDS.toMillis(180); // 3 minutes before destroying the lobby
        LobbyWatcher watcher = new LobbyWatcher(id, expirationTime);
        watcherQueue.add(watcher);
        watcherMap.put(id, watcher);

        if (isSchedulerRunning.compareAndSet(false, true)) {
            startScheduler();
        }
    }

    public void refreshWatcher(String id) {
        LobbyWatcher watcher = watcherMap.get(id);
        if (watcher != null) {
            watcherQueue.remove(watcher); // Remove the old instance
        }
        addWatcher(id); // Add a new one with an updated timestamp
    }

    public void stopWatcher(String id) {
        LobbyWatcher watcher = watcherMap.remove(id);
        if (watcher != null) {
            watcherQueue.remove(watcher); // Remove from the queue
        }
    }

    private synchronized void ensureSchedulerRunning() {
        if (scheduler == null || scheduler.isShutdown() || scheduler.isTerminated()) {
            scheduler = Executors.newSingleThreadScheduledExecutor();
        }
    }


        private record LobbyWatcher(String id, long expirationTime) implements Comparable<LobbyWatcher> {

        @Override
            public int compareTo(LobbyWatcher other) {
                return Long.compare(this.expirationTime, other.expirationTime);
            }
        }

    public interface CleanUpCallback {
        void onCleanUp(String lobbyId);
    }
}
