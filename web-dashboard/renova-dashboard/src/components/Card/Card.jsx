import "./Card.css"
//MUI Icons
import FolderIcon from '@mui/icons-material/Folder';
export default function Card({number, title, iconright}) {
    return (
        <div>
            <div className="stat-card">
                <div className="stat-left">
                    <h2>{number}</h2>
                    <p><FolderIcon sx={{ color: "#f07c1f" }} fontSize="small"/> {title}</p>
                </div>
                <div className="stat-right">
                    {iconright}
                </div>
            </div>
        </div>
    )
}