import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const SUPABASE_URL = 'https://oymmmevtzbzoneujtkhn.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im95bW1tZXZ0emJ6b25ldWp0a2huIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzgwMTE4MTQsImV4cCI6MjA5MzU4NzgxNH0.sRrw5cthKfF7k0vP0_ONCLiQN6J4CIerzzu5NRUCXlU';

export const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
