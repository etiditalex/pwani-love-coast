'use client';

import { useEffect, useState } from 'react';
import { supabase } from '@/lib/supabase';
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';
import { format, subDays } from 'date-fns';

interface GrowthData {
  date: string;
  users: number;
}

export default function UserGrowth() {
  const [data, setData] = useState<GrowthData[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadUserGrowth();
  }, []);

  async function loadUserGrowth() {
    try {
      const { data: profiles, error } = await supabase
        .from('profiles')
        .select('created_at')
        .order('created_at', { ascending: true });

      if (error) throw error;

      // Group by date
      const last30Days = Array.from({ length: 30 }, (_, i) => {
        const date = subDays(new Date(), 29 - i);
        return format(date, 'MMM d');
      });

      const growthData = last30Days.map((dateLabel) => {
        const date = subDays(new Date(), 29 - last30Days.indexOf(dateLabel));
        const count = profiles?.filter((p) => {
          const profileDate = new Date(p.created_at);
          return (
            profileDate.getDate() === date.getDate() &&
            profileDate.getMonth() === date.getMonth() &&
            profileDate.getFullYear() === date.getFullYear()
          );
        }).length || 0;

        return { date: dateLabel, users: count };
      });

      // Calculate cumulative
      let cumulative = 0;
      const cumulativeData = growthData.map((item) => {
        cumulative += item.users;
        return { ...item, users: cumulative };
      });

      setData(cumulativeData);
    } catch (error) {
      console.error('Error loading user growth:', error);
    } finally {
      setLoading(false);
    }
  }

  if (loading) {
    return (
      <div className="bg-white rounded-lg shadow-md p-6">
        <h2 className="text-xl font-bold mb-4">User Growth</h2>
        <div className="text-center py-8">Loading...</div>
      </div>
    );
  }

  return (
    <div className="bg-white rounded-lg shadow-md p-6">
      <h2 className="text-xl font-bold mb-4">User Growth (Last 30 Days)</h2>
      <ResponsiveContainer width="100%" height={300}>
        <LineChart data={data}>
          <CartesianGrid strokeDasharray="3 3" />
          <XAxis dataKey="date" />
          <YAxis />
          <Tooltip />
          <Line
            type="monotone"
            dataKey="users"
            stroke="#4A90E2"
            strokeWidth={2}
          />
        </LineChart>
      </ResponsiveContainer>
    </div>
  );
}

