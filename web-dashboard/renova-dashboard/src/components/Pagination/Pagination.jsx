import Pagination from "@mui/material/Pagination";
import PaginationItem from "@mui/material/PaginationItem";

export default function TablePagination({count,page,onChange}) {
    return (
        <Pagination 
            count={count}
            page={page}
            onChange={onChange} 
            color="warning"
            showFirstButton
            showLastButton
            sx={{direction: "ltr",}}
            renderItem={(item) => (
        <PaginationItem
            {...item}
            selected={item.type === "page" && item.page === page}
            sx={{fontFamily: "Tajawal !important",}}
                    />)}
                />        
            );
        }