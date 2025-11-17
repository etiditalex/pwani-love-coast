'use client';

import { useEffect, useState } from 'react';
import { supabase } from '@/lib/supabase';
import { Match, Profile } from '@/types/database';
import { format } from 'date-fns';

export default function RecentMatches() {
  const [matches, setMatches] = useState<(Match & { profileA?: Profile; profileB?: Profile })[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadRecentMatches();
  }, []);

  async function loadRecentMatches() {
    try {
      const { data, error } = await supabase
        .from('matches')
        .select('*')
        .order('created_at', { ascending: false })
        .limit(10);

      if (error) throw error;

      // Load profiles for each match
      const matchesWithProfiles = await Promise.all(
        (data || []).map(async (match) => {
          const [profileA, profileB] = await Promise.all([
            supabase.from('profiles').select('*').eq('id', match.user_a).single(),
            supabase.from('profiles').select('*').eq('id', match.user_b).single(),
          ]);

          return {
            ...match,
            profileA: profileA.data as Profile | undefined,
            profileB: profileB.data as Profile | undefined,
          };
        })
      );

      setMatches(matchesWithProfiles);
    } catch (error) {
      console.error('Error loading matches:', error);
    } finally {
      setLoading(false);
    }
  }

  if (loading) {
    return (
      <div className="bg-white rounded-lg shadow-md p-6">
        <h2 className="text-xl font-bold mb-4">Recent Matches</h2>
        <div className="text-center py-8">Loading...</div>
      </div>
    );
  }

  return (
    <div className="bg-white rounded-lg shadow-md p-6">
      <h2 className="text-xl font-bold mb-4">Recent Matches</h2>
      <div className="space-y-4">
        {matches.length === 0 ? (
          <p className="text-gray-500 text-center py-8">No matches yet</p>
        ) : (
          matches.map((match) => (
            <div
              key={match.id}
              className="border-b border-gray-200 pb-4 last:border-0"
            >
              <div className="flex items-center justify-between">
                <div>
                  <p className="font-medium">
                    {match.profileA?.display_name || 'Unknown'} &{' '}
                    {match.profileB?.display_name || 'Unknown'}
                  </p>
                  <p className="text-sm text-gray-500">
                    {format(new Date(match.created_at), 'MMM d, yyyy')}
                  </p>
                </div>
              </div>
            </div>
          ))
        )}
      </div>
    </div>
  );
}

