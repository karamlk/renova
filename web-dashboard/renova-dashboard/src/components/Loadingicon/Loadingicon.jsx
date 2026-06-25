import CircularProgress from '@mui/material/CircularProgress';
import Box from '@mui/material/Box';
export default function Loadingicon() {
    return (
        <Box sx={{ display: 'flex', justifyContent: 'center', alignItems: 'center',height: '100vh',width: '80vw'}}>
      <CircularProgress aria-label="Loading…" sx={{ color: '#F07C1F'}} size={45}/>
    </Box>
    )
}