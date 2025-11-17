'use client';

import { useEffect, useState } from 'react';
import { supabase } from '@/lib/supabase';
import { Profile, Match, Like, Message } from '@/types/database';
import StatsCard from '@/components/StatsCard';
import RecentMatches from '@/components/RecentMatches';
import UserGrowth from '@/components/UserGrowth';

export default function Dashboard() {
  const [stats, setStats] = useState({
    totalUsers: 0,
    totalMatches: 0,
    totalLikes: 0,
    totalMessages: 0,
  });
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadStats();
  }, []);

  async function loadStats() {
    try {
      // Check if Supabase is configured
      const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
      if (!supabaseUrl || supabaseUrl.includes('placeholder')) {
        console.warn('Supabase not configured. Please set environment variables in Vercel.');
        setLoading(false);
        return;
      }

      const [profiles, matches, likes, messages] = await Promise.all([
        supabase.from('profiles').select('id', { count: 'exact', head: true }),
        supabase.from('matches').select('id', { count: 'exact', head: true }),
        supabase.from('likes').select('id', { count: 'exact', head: true }),
        supabase.from('messages').select('id', { count: 'exact', head: true }),
      ]);

      setStats({
        totalUsers: profiles.count || 0,
        totalMatches: matches.count || 0,
        totalLikes: likes.count || 0,
        totalMessages: messages.count || 0,
      });
    } catch (error) {
      console.error('Error loading stats:', error);
    } finally {
      setLoading(false);
    }
  }

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-xl">Loading...</div>
      </div>
    );
  }

  return (
    <div className="min-h-screen p-8">
      <div className="max-w-7xl mx-auto">
        <h1 className="text-4xl font-bold mb-8 text-primary-700">
          Pwani Love Admin Dashboard
        </h1>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
          <StatsCard
            title="Total Users"
            value={stats.totalUsers}
            icon="👥"
            color="bg-primary-500"
          />
          <StatsCard
            title="Total Matches"
            value={stats.totalMatches}
            icon="💕"
            color="bg-coral-400"
          />
          <StatsCard
            title="Total Likes"
            value={stats.totalLikes}
            icon="👍"
            color="bg-teal"
          />
          <StatsCard
            title="Total Messages"
            value={stats.totalMessages}
            icon="💬"
            color="bg-primary-600"
          />
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          <RecentMatches />
          <UserGrowth />
        </div>
      </div>
    </div>
  );
}

