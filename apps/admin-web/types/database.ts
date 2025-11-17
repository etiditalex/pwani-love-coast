export interface Profile {
  id: string;
  display_name: string;
  age: number | null;
  gender: string | null;
  looking_for: string | null;
  bio: string | null;
  interests: string[] | null;
  avatar_url: string | null;
  photos: string[] | null;
  latitude: number | null;
  longitude: number | null;
  created_at: string;
  updated_at: string | null;
}

export interface Match {
  id: number;
  user_a: string;
  user_b: string;
  created_at: string;
  last_activity_at: string;
}

export interface Like {
  id: number;
  from_user: string;
  to_user: string;
  created_at: string;
}

export interface Message {
  id: number;
  match_id: number;
  sender_id: string;
  body: string;
  read_at: string | null;
  created_at: string;
}

